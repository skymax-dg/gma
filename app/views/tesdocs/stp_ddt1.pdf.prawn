	pdf = Prawn::Document.new(:page_layout   => :portrait, 
                            :left_margin   => 1.2.cm, :right_margin  => 1.2.cm,
                            :top_margin    => 1.2.cm, :bottom_margin => 1.2.cm,
                            :page_size => 'A4')

  #titolo documento
	pdf.bounding_box [240,780], :width => 290, :height => 80 do
		pdf.stroke_bounds
	end


# stampa logo immagine
pdf.bounding_box [280,775], :width => 240, :height => 50 do
  pdf.image "#{Rails.root}/app/assets/images/logos/Eifis.jpg", :fit => [240,50]
end
  pdf.text_box @tit_doc[0],
	             :at => [250,725],  :width => 280, :height => 12, :size => 12, :style => :bold,
               :align => :center, :overflow => :shrink_to_fit, :min_font_size => 8
  pdf.text_box @tit_doc[1],
	             :at => [250,710], :width => 280, :height => 24, :size => 8, :align => :center

  #Mittente
	pdf.bounding_box [0,780], :width => 240, :height => 80 do
		pdf.stroke_bounds
	end
  testo=""
  testo="Part.Iva: #{@ana.pariva}\n" if @ana.pariva && @ana.pariva.length > 0
  testo+="C.F.:#{@ana.codfis}\n" if testo == "" && @ana.codfis && @ana.codfis.length > 0
  testo+="Tel:#{@ana.telefono}" if @ana.telefono && @ana.telefono.length > 0
  testo+=" / " if @ana.telefono && @ana.fax && @ana.telefono.length > 0 && @ana.fax.length > 0
  testo+="Fax:#{@ana.fax}" if @ana.fax && @ana.fax.length > 0
  testo+="\n"
  testo+="EMail:#{@ana.email}" if @ana.email && @ana.email.length > 0
  testo+=" / " if @ana.email && @ana.web && @ana.email.length > 0 && @ana.web.length > 0
  testo+="Web:#{@ana.web}" if @ana.web && @ana.web.length > 0
  pdf.formatted_text_box [{:text => "Mitt: #{@ana.denomin.upcase}\n", :styles => [:bold], :size => 12},
                          {:text => "#{@sl[:indir]}\n#{@sl[:desloc]}\n"},
                          {:text => testo}],
                         :at => [2,777], :width => 238, :height => 77,
                         :overflow => :shrink_to_fit, :size => 10, :min_font_size => 6

  #Destinatario
	pdf.bounding_box [0,700], :width => 240, :height => 95 do
		pdf.stroke_bounds
	end

  testo=""
  testo="Part.Iva: #{@anad.pariva}\n" if @anad.pariva && @anad.pariva.length > 0
  testo+="C.F.:#{@anad.codfis} " if testo == "" && @anad.codfis && @anad.codfis.length > 0
  testo+="Tel:#{@anad.telefono} " if @anad.telefono && @anad.telefono.length > 0
  testo+="EMail:#{@anad.email} " if @anad.email && @anad.email.length > 0
  testo+="/ " if @anad.email && @anad.web && @anad.email.length > 0 && @anad.web.length > 0
  testo+="Web:#{@anad.web}" if @anad.web && @anad.web.length > 0
  pdf.formatted_text_box [{:text => "Dest: #{@anad.denomin.upcase}\n", :styles => [:bold], :size => 12},
                          {:text => "#{@sld[:indir]}\n#{@sld[:desloc]}\n"},
                          {:text => testo}],
                         :at => [2,698], :width => 238, :height => 93,
                         :overflow => :shrink_to_fit, :size => 10, :min_font_size => 6
  #Presso e luogo di destinazione
  pdf.bounding_box [240,730], :width => 290, :height => 125 do
    pdf.stroke_bounds
  end

  testo=""
  testo+="Tel:#{@anad.telefono} " if @anad.telefono && @anad.telefono.length > 0
	unless @datispe.nil? || "#{@datispe.dest1}#{@datispe.dest2}".blank?
    pdf.text_box "Luogo di consegna",
                 :at => [245, 698], :height => 15, :size => 12, :style => :bold

    pdf.formatted_text_box [{:text => "Presso: #{@datispe.presso.upcase}\n", :styles => [:bold], :size => 12},
                            {:text => "#{@datispe.dest1}\n#{@datispe.dest2}\n"},
                            {:text => testo}],
                           :at => [260,685], :width => 268, :height => 73,
                           :overflow => :shrink_to_fit, :size => 10, :min_font_size => 6
	end

  #Riferimenti documento e causale/corriere
	pdf.bounding_box [0,605], :width => 530, :height => 35 do
		pdf.stroke_bounds
	end
  testo = "Documento Nr. #{@rifdoc[:nr].to_s.rjust(5, '0')}"
  testo+= "/#{@tesdoc.causmag.sfx.strip}" if @tesdoc.causmag.sfx && @tesdoc.causmag.sfx.strip.length > 0
  testo+= "/#{@tesdoc.annoese} del #{@rifdoc[:dt].strftime("%d/%m/%Y")}"


  pdf.text_box testo,
               :at => [2, 620], :width => 240, :height => 20, :size => 12, :style => :bold

	#pdf.bounding_box [0,600], :width => 260, :height => 50 do
	  #Causale di trasp
    #pdf.stroke_bounds
	#end
  pdf.formatted_text_box [{:text => "Causale di trasporto: ", :styles => [:bold]},
                          {:text => @tesdoc.causmag.caus_tra||""}],
                         :at => [2, 590], :width => 280, :height => 20, :size => 10

  #Corriere
	#pdf.bounding_box [280,600], :width => 250, :height => 50 do
    #pdf.stroke_bounds
	#end

  pdf.formatted_text_box [{:text => "A mezzo: ", :styles => [:bold]},
                          {:text => Spediz::CORRIERE[(@datispe&&@datispe.corriere)||""]||""}],
                          :at => [270, 590], :width => 260, :height => 45, :size => 10

  pdf.move_down 7
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

	#note
  if (not @datispe.nil?) && @datispe.corriere == "GLS" && @anad.email && (not @anad.email.blank?)
    @datispe.note = "Nota specifica per #{@datispe.corriere} - INVIO NOTIFICA: #{@anad.email}\n#{@datispe.note}"||""
  end
  unless @datispe.nil? || @datispe.note.nil? || @datispe.note.blank?
    #Esegue salto pagina se non è rimasto abbastanza spazio per le note
    pdf.start_new_page if pdf.cursor < 175
    
    pdf.text_box "Annotazioni:",
                 :at => [2, 178], :width => 80, :height => 12, :size => 10, :style => :bold
    pdf.text_box "#{@datispe.note}",
                 :at => [70, 178], :width => 450, :height => 105, :size => 8
  end

	#Piede documento (aspetto - colli - um/valore - porto)
  #Esegue salto pagina se non è rimasto abbastanza spazio per i dati di piede
  pdf.start_new_page if pdf.cursor < 100

  render :partial=>'piede_doc.pdf.prawn', :locals=>{:ppdf=>pdf}

  #Numerazione delle pagine
  pdf.page_count.times do |page|
    pdf.go_to_page(page+1)
    pdf.draw_text "Pag. #{page+1} di #{pdf.page_count}",
                  :at => [480, 6], :size => 8
  end
