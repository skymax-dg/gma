  pdf = Prawn::Document.new(:page_layout   => :portrait, 
                            :left_margin   => 1.2.cm, :right_margin  => 1.2.cm,
                            :top_margin    => 1.2.cm, :bottom_margin => 1.2.cm,
                            :page_size => 'A4')
  
  # Non devono essere riportati i dati di spedizione.
  @ddt=0
  @referente="C.A. Sig. #{@tesdoc.conto.anagen.referente}" if @tesdoc.conto.anagen.referente&&(not @tesdoc.conto.anagen.referente.blank?)
  render :partial=>'testafatt.pdf.prawn', :locals=>{:ppdf=>pdf}

  pdf.bounding_box [0,605], :width => 530, :height => 30 do
    pdf.stroke_bounds
  end
  pdf.formatted_text_box [{:text => "OGGETTO: ", :styles => [:bold]},
                          {:text => "Ritiro libri in c/to deposito #{Anagen.find(@tesdoc.azienda).denomin}", :size => 14, :styles => [:bold]}],
                           :at => [2, 590], :width => 280, :height => 20, :size => 10
  pdf.move_down 10

  pdf.text "DETTAGLIO ARTICOLI", :size => 14, :style => :bold, :align => :center
  #Array Intestazione e righe
  @tb = Array.new(1,["CODICE", "DESCRIZIONE", "Q.TA'"])
  @tqta=0
  @tesdoc.rigdocs.each do |r|
    qta = r.qta > 0 ? r.qta : ""
    @tb<<[""&&r.article&&r.article.codice, r.descriz, qta]&&@tqta+=r.qta
  end
  @tb << ["TOTALE", "", @tqta==0 ? "" : @tqta]

  #Creazione e stampa tabella articoli
  tab = pdf.make_table(@tb, :column_widths=>{0=>120,1=>357, 2=>50})
  tab.row(0).font_style = :bold
  tab.row(tab.row_length-1).font_style = :bold
  tab.header = true
  tab.column(0).style :align => :left
  tab.column(1).style :align => :left
  tab.column(2).style :align => :right
  tab.draw

  pdf.move_down 20

  if @datispe.nil? || @datispe.note.nil? || @datispe.note.blank?
    #Esegue salto pagina se non è rimasto abbastanza spazio per i finali
    if pdf.cursor < 180
      pdf.start_new_page
      render :partial=>'testafatt.pdf.prawn', :locals=>{:ppdf=>pdf}
    end
  else
    #Esegue salto pagina se non è rimasto abbastanza spazio per le note
    if pdf.cursor < 350
      pdf.start_new_page
      render :partial=>'testafatt.pdf.prawn', :locals=>{:ppdf=>pdf}
    end
  end

  testo="Vi ringraziamo della cortese collaborazione.\nCordialmente.\n#{Anagen.find(@tesdoc.azienda).denomin}\n#{@tesdoc.conto.anagen.referente}\n"
  pdf.text testo, :size => 10

  testo="E' stato predisposto il ritiro "
  testo+="da parte del corriere #{Spediz::CORRIERE[(@datispe.corriere)]} " if @datispe&&@datispe.corriere
  testo+="per il giorno #{@datispe.dtrit.strftime('%d/%m/%Y')} " if @datispe&&@datispe.dtrit
  testo+="alle ore #{@datispe.orarit.strftime('%H:%M')}" if @datispe&&@datispe.orarit.strftime('%H:%M')!="00:00"

  pdf.move_down 20
  pdf.text testo, :size => 14, :style => :bold

  #note
  pdf.text_box "Annotazioni_: #{@datispe.note}",
               :at => [2, 178], :width => 80, :height => 12, :size => 10, :style => :bold
  pdf.text_box "#{@datispe.note}",
               :at => [70, 178], :width => 450, :height => 105, :size => 8

  #Numerazione delle pagine
  pdf.page_count.times do |page|
    pdf.go_to_page(page+1)
    pdf.draw_text "Pag. #{page+1} di #{pdf.page_count}",
                  :at => [480, 6], :size => 8
  end
