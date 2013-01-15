  pdf = Prawn::Document.new(:page_layout   => :portrait, 
                            :left_margin   => 1.2.cm, :right_margin  => 1.2.cm,
                            :top_margin    => 1.2.cm, :bottom_margin => 1.2.cm,
                            :page_size => 'A4')
  
  #pdf.bounding_box [0,780], :width => 530, :height => 780 do
    #Cornice intero documento
    #pdf.stroke_bounds
  #end

  # do per scontato che se è stata specificata una causale di trasporto allora il documeno deve riportare anche
  # i dati DDT.
  @datispe && @datispe.corriere && (not @datispe.corriere.blank?) ? @ddt = 1 : @ddt=0

  render :partial=>'testafatt.pdf.prawn', :locals=>{:ppdf=>pdf}
  pdf.text "DETTAGLIO ARTICOLI", :size => 14, :style => :bold, :align => :center
  @tb = Array.new(1, ["CODICE", "DESCRIZIONE", "Q.TA", "PRZ.\nLIST.", "TOT.\nLIST.", "PRZ.\nSCN.", "IMPON.", "IVA"])
  @tqta=0
  @tlist=0
  @timpon=0
  @timposta=0
  @tesdoc.rigdocs.each do |r|
    if r.qta > 0
      @tb<<[""&&r.article&&r.article.codice, r.descriz, r.qta, 
            number_with_precision(0&&r.article&&r.article.prezzo), number_with_precision(r.imp_list),
            number_with_precision(r.prezzo), number_with_precision(r.impon), ""&&r.iva&&r.iva.descriz]
    else
      @tb<<[""&&r.article&&r.article.codice, r.descriz, "", 
            "", "",
            "", "", ""&&r.iva&&r.iva.descriz]
    end
    @tqta+=r.qta
    @timpon+=r.impon
    @tlist+=r.imp_list
  end
  @tb << ["TOTALE", "", @tqta, "", number_with_precision(@tlist), "", number_with_precision(@timpon), ""]#number_with_precision(@timposta)]

  #Creazione e stampa tabella articoli
  tab = pdf.make_table(@tb, :column_widths=>{0=>80, 1=>195, 2=>30, 3=>35, 4=>50, 5=>35, 6=>50, 7=>50},
                            :cell_style => {:size => 8})
  tab.row(0).font_style = :bold
  tab.row(tab.row_length-1).font_style = :bold
  tab.header = true
  tab.column(2..6).style :align => :right
  tab.draw

  pdf.move_down 27

  #Array Intestazione e righe (RIEPILOGO IMPONIBILI)
  @tb = Array.new(1, ["CATEGORIA", "IMPONIBILE", "IVA/ESENZ.", "IMPOSTA", "TOTALE"])
  sub_iva = @tesdoc.subtot_iva
  sub_iva.each_key do |categ|
    sub_iva[categ].each_key do |k|
      @tb << [Article::CATEG[categ], number_with_precision(sub_iva[categ][k][:impon]), sub_iva[categ][k][:des], number_with_precision(sub_iva[categ][k][:imposta]), number_with_precision(sub_iva[categ][k][:tot])] unless k == :T
    end
  end
  @tb << [sub_iva[:T][:T][:desest], number_with_precision(sub_iva[:T][:T][:impon]), sub_iva[:T][:T][:des], number_with_precision(sub_iva[:T][:T][:imposta]), number_with_precision(sub_iva[:T][:T][:tot])]

  #Stampa tabella riepilogativa
  # Salto pagina se non c'è abbastanza spazio per il riepilogo impobnibili
  if pdf.cursor < @tb.count * 10 + 65
    pdf.start_new_page 
    render :partial=>'testafatt.pdf.prawn', :locals=>{:ppdf=>pdf}
  end

  pdf.text "RIEPILOGO IMPONIBILI", :size => 14, :style => :bold, :align => :center
  tab = pdf.make_table(@tb, :column_widths=>{0=>160, 1=> 80, 2=>120, 3=>80, 4=>87}, :cell_style => {:size => 10})
  tab.row(0).font_style = :bold
  tab.row(tab.row_length-1).font_style = :bold
  tab.header = true
  tab.column(0).style :align => :left
  tab.column(1..4).style :align => :right
  tab.draw

  #dati pagamento
  unless @datispe.nil? || @datispe.pagam.nil? || @datispe.pagam.blank?
    #Esegue salto pagina se non è rimasto abbastanza spazio per le note
    if pdf.cursor < 300
      pdf.start_new_page
      render :partial=>'testafatt.pdf.prawn', :locals=>{:ppdf=>pdf}
    else
      pdf.move_cursor_to(310)
    end
    
    pdf.text "Pagamento:", :size => 12, :style => :bold
    pdf.text @datispe.pagam, :size => 10
#    pdf.text "Pagamento: #{@datispe.pagam}", :size => 10
    pdf.text "Banca:", :size => 12, :style => :bold
    pdf.text @datispe.banca, :size => 10
#    pdf.text "Banca: #{@datispe.banca}", :size => 10
  end

  #note
  unless @datispe.nil? || @datispe.note.nil? || @datispe.note.blank?
    #Esegue salto pagina se non è rimasto abbastanza spazio per le note
    if pdf.cursor < 180
      pdf.start_new_page
      render :partial=>'testafatt.pdf.prawn', :locals=>{:ppdf=>pdf}
    end
    
    pdf.text_box "Annotazioni: #{@datispe.note}",
                 :at => [2, 178], :width => 80, :height => 12, :size => 10, :style => :bold
    pdf.text_box "#{@datispe.note}",
                 :at => [70, 178], :width => 450, :height => 105, :size => 8
  end

  if @ddt == 1
    pdf.bounding_box [0,80], :width => 530, :height => 30 do
      pdf.stroke_bounds
    end
    pdf.draw_text "Aspetto esteriore dei beni",
                  :at => [2, 70], :size => 10, :style => :bold
    pdf.draw_text "Nr.Colli",
                  :at => [200, 70], :size => 10, :style => :bold
    pdf.draw_text "#{@datispe&&@datispe.um}",
                  :at => [300, 70], :size => 10, :style => :bold
    pdf.draw_text "Porto",
                  :at => [400, 70], :size => 10, :style => :bold
    pdf.draw_text Spediz::ASPETTO[(@datispe&&@datispe.aspetto)||""]||"",
                  :at => [2, 57], :size => 10
    pdf.draw_text @datispe&&@datispe.nrcolli.to_s,
                  :at => [200, 57], :size => 10
    pdf.draw_text @datispe&&@datispe.valore.to_s,
                  :at => [300, 57], :size => 10
    pdf.draw_text Spediz::PORTO[(@datispe&&@datispe.porto)]||"",
                  :at => [400, 57], :size => 10

    # data e ora ritiro
    pdf.bounding_box [0,50], :width => 530, :height => 35 do
      pdf.stroke_bounds
    end
    pdf.draw_text "Data del ritiro",
                  :at => [2, 40], :size => 10, :style => :bold
    pdf.draw_text "Ora del ritiro",
                  :at => [130, 40], :size => 10, :style => :bold
    pdf.draw_text @datispe&&@datispe.dtrit&&@datispe.dtrit.strftime("%d/%m/%Y"),
                  :at => [5, 27], :size => 10 if @datispe&&@datispe.aspetto
    pdf.draw_text @datispe&&@datispe.orarit&&@datispe.orarit.strftime("%H:%M"),
                  :at => [135, 27], :size => 10 if @datispe&&@datispe.aspetto

  # spazio pe la firma
    pdf.draw_text "Firma",
                  :at => [400, 40], :size => 10, :style => :bold
  end
  #Numerazione delle pagine
  pdf.page_count.times do |page|
    pdf.go_to_page(page+1)
    pdf.draw_text "Pag. #{page+1} di #{pdf.page_count}",
                  :at => [480, 6], :size => 8
  end
