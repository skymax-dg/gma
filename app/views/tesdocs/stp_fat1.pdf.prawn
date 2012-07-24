  pdf = Prawn::Document.new(:page_layout   => :portrait, 
                            :left_margin   => 1.2.cm, :right_margin  => 1.2.cm,
                            :top_margin    => 1.2.cm, :bottom_margin => 1.2.cm,
                            :page_size => 'A4')
  
  #pdf.bounding_box [0,780], :width => 530, :height => 780 do
    #Cornice intero documento
    #pdf.stroke_bounds
  #end

  #titolo documento
  pdf.bounding_box [240,780], :width => 290, :height => 40 do
    pdf.stroke_bounds
  end
  pdf.text_box @tit_doc[0],
               :at => [250,770],  :width => 280, :height => 12, :size => 12, :style => :bold,
               :align => :center, :overflow => :shrink_to_fit, :min_font_size => 8
  pdf.text_box @tit_doc[1],
               :at => [250,760], :width => 280, :height => 24, :size => 8, :align => :center

  #Mittente
  pdf.bounding_box [0,780], :width => 240, :height => 190 do
    pdf.stroke_bounds
  end
  pdf.formatted_text_box [{:text => "#{@ana.denomin.upcase}\n", :styles => [:bold], :size => 12},
                          {:text => "Part.Iva: #{@ana.pariva}\n"},
                          {:text => "#{@sl[:indir]}\n#{@sl[:cap]} #{@sld[:desloc]}\n"},
                          {:text => "Tel: #{@ana.telefono} / Fax: #{@ana.fax}\n"},
                          {:text => "E-Mail: #{@ana.email} / Web: #{@ana.web}"}
                          ],
                         :at => [2,777], :width => 238, :height => 185,
                         :overflow => :shrink_to_fit, :size => 10, :min_font_size => 6

  #Destinatario
  pdf.bounding_box [240,740], :width => 290, :height => 170 do
    pdf.stroke_bounds
  end
  pdf.formatted_text_box [{:text => "Spett.le: #{@anad.denomin.upcase}\n", :styles => [:bold], :size => 12},
                          {:text => "Part.Iva: #{@anad.pariva}\n"},
                          {:text => "#{@sld[:indir]}\n#{@sld[:cap]} #{@sld[:desloc]}\n"},
                          {:text => "E-Mail: #{@anad.email} / Web: #{@anad.web}"}],
                         :at => [242,698], :width => 286, :height => 158,
                         :overflow => :shrink_to_fit, :size => 10, :min_font_size => 6
  #Riferimenti documento
  pdf.bounding_box [0,590], :width => 240, :height => 20 do
    pdf.stroke_bounds
  end
  pdf.text_box "FATTURA Nr. #{@rifdoc[:nr]} del #{@rifdoc[:dt]}",
               :at => [2, 584], :width => 240, :height => 15, :size => 12, :style => :bold

  pdf.move_down 25
  @tb = Array.new
  @tb << ["CODICE", "DESCRIZIONE", "Q.TA", "PRZ.\nLIST.", "PRZ.\nSCN.", "IMPON.", "IVA"]#, "IMPOSTA"]
  @tqta=0
  @timpon=0
  @timposta=0
  @tesdoc.rigdocs.each do |r|
    @tb<<[r.article.codice, r.descriz,     r.qta, number_with_precision(r.article.prezzo),
          number_with_precision(r.prezzo), number_with_precision(r.impon),
          r.iva.descriz]
#number_with_precision(r.imposta)]}
    @tqta+=r.qta
    @timpon+=r.impon
    #@timposta+=r.imposta
  end
  @tb << ["TOTALE", "", @tqta, "", "", number_with_precision(@timpon), ""]#number_with_precision(@timposta)]

  #Creazione e stampa tabella articoli
  tab = pdf.make_table(@tb, :column_widths=>{0=>80, 3=>35, 4=>35}, :cell_style => {:size => 8})
  tab.row(0).font_style = :bold
  tab.row(tab.row_length-1).font_style = :bold
  tab.header = true
  tab.column(2).style :align => :right
  tab.column(3).style :align => :right
  tab.column(4).style :align => :right
  tab.column(5).style :align => :right
  #tab.column(7).style :align => :right
  tab.draw

  pdf.move_down 27

  #Array Intestazione e righe (RIEPILOGO IMPONIBILI)
  @tb = Array.new
  @tb << ["CATEGORIA", "IMPONIBILE", "IVA/ESENZ.", "IMPOSTA", "TOTALE"]
  sub_iva = @tesdoc.subtot_iva
  sub_iva.each_key do |categ|
    sub_iva[categ].each_key do |k|
      @tb << [Article::CATEG[categ], number_with_precision(sub_iva[categ][k][:impon]), sub_iva[categ][k][:des], number_with_precision(sub_iva[categ][k][:imposta]), number_with_precision(sub_iva[categ][k][:tot])] unless k == :T
    end
  end
  @tb << [sub_iva[:T][:T][:desest], number_with_precision(sub_iva[:T][:T][:impon]), sub_iva[:T][:T][:des], number_with_precision(sub_iva[:T][:T][:imposta]), number_with_precision(sub_iva[:T][:T][:tot])]

  #Stampa tabella riepilogativa
  # Salto pagina se non c'è abbastanza spazio per il riepilogo impobnibili
  pdf.start_new_page if pdf.cursor < @tb.count * 10 + 65

  pdf.text "RIEPILOGO IMPONIBILI", :size => 14, :style => :bold, :align => :center
  tab = pdf.make_table(@tb, :column_widths=>{0=>160, 1=> 80, 2=>120, 3=>80, 4=>87}, :cell_style => {:size => 10})
  tab.row(0).font_style = :bold
  tab.row(tab.row_length-1).font_style = :bold
  tab.header = true
  tab.column(0).style :align => :left
  tab.column(1..4).style :align => :right
  tab.draw

  #note
  unless @datispe.note.nil? || @datispe.note.strip.length == 0
    #Esegue salto pagina se non è rimasto abbastanza spazio per le note
    pdf.start_new_page if pdf.cursor < 70
    
    pdf.text_box "Annotazioni: #{@datispe.note}",
                 :at => [2, 70], :width => 80, :height => 12, :size => 10, :style => :bold
    pdf.text_box "#{@datispe.note}",
                 :at => [70, 70], :width => 250, :height => 70, :size => 10
  end

  #Numerazione delle pagine
  pdf.page_count.times do |page|
    pdf.go_to_page(page+1)
    pdf.draw_text "Pag. #{page+1} di #{pdf.page_count}",
                  :at => [480, 6], :size => 8
  end
