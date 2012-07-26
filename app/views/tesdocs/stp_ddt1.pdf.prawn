	pdf = Prawn::Document.new(:page_layout   => :portrait, 
                            :left_margin   => 1.2.cm, :right_margin  => 1.2.cm,
                            :top_margin    => 1.2.cm, :bottom_margin => 1.2.cm,
                            :page_size => 'A4')
	
  #pdf.bounding_box [0,780], :width => 530, :height => 780 do
	  #Cornice intero documento
    #pdf.stroke_bounds
	#end

  #titolo documento
	pdf.bounding_box [240,780], :width => 290, :height => 50 do
		pdf.stroke_bounds
	end
  pdf.text_box @tit_doc[0],
	             :at => [250,770],  :width => 280, :height => 12, :size => 12, :style => :bold,
               :align => :center, :overflow => :shrink_to_fit, :min_font_size => 8
  pdf.text_box @tit_doc[1],
	             :at => [250,760], :width => 280, :height => 24, :size => 8, :align => :center

  #Mittente
	pdf.bounding_box [0,780], :width => 240, :height => 80 do
		pdf.stroke_bounds
	end
  pdf.formatted_text_box [{:text => "Mitt: #{@ana.denomin.upcase}\n", :styles => [:bold], :size => 12},
                          {:text => "Part.Iva: #{@ana.pariva}\n"},
                          {:text => "#{@sl[:indir]}\n#{@sl[:desloc]}\n"},
                          {:text => "Tel: #{@ana.telefono} / Fax: #{@ana.fax}\n"},
                          {:text => "E-Mail: #{@ana.email} / Web: #{@ana.web}"}
                          ],
                         :at => [2,777], :width => 238, :height => 77,
                         :overflow => :shrink_to_fit, :size => 10, :min_font_size => 6

  #Destinatario
	pdf.bounding_box [0,700], :width => 240, :height => 95 do
		pdf.stroke_bounds
	end
  pdf.formatted_text_box [{:text => "Dest: #{@anad.denomin.upcase}\n", :styles => [:bold], :size => 12},
                          {:text => "Part.Iva: #{@anad.pariva}\n"},
                          {:text => "#{@sld[:indir]}\n#{@sld[:desloc]}"}],
                         :at => [2,698], :width => 238, :height => 93,
                         :overflow => :shrink_to_fit, :size => 10, :min_font_size => 6
  #Presso e luogo di destinazione
  pdf.bounding_box [240,730], :width => 290, :height => 100 do
    pdf.stroke_bounds
  end

	unless @datispe.nil? || "#{@datispe.dest1}#{@datispe.dest2}".strip.length == 0
    pdf.text_box "Luogo di consegna",
                 :at => [245, 720], :height => 15, :size => 12, :style => :bold

    pdf.formatted_text_box [{:text => "Presso: #{@datispe.presso.upcase}\n", :styles => [:bold], :size => 12},
                            {:text => "#{@datispe.dest1}\n#{@datispe.dest2}"}],
                           :at => [260,705], :width => 268, :height => 73,
                           :overflow => :shrink_to_fit, :size => 10, :min_font_size => 6
	end

  #Riferimenti documento e causale/corriere
	pdf.bounding_box [0,630], :width => 530, :height => 60 do
		pdf.stroke_bounds
	end
  pdf.text_box "Documento Nr. #{@rifdoc[:nr]} del #{@rifdoc[:dt].strftime("%d/%m/%Y")}",
               :at => [2, 620], :width => 240, :height => 20, :size => 12, :style => :bold

	#pdf.bounding_box [0,600], :width => 260, :height => 50 do
	  #Causale di trasp
    #pdf.stroke_bounds
	#end
  pdf.formatted_text_box [{:text => "Causale di trasporto: ", :styles => [:bold]},
                          {:text => Spediz::CAUSTRA[(@datispe&&@datispe.caustra)||""]||""}],
                         :at => [2, 590], :width => 240, :height => 20, :size => 10

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
  @tesdoc.rigdocs.each {|r|@tb<<[r.article.codice, r.descriz, r.qta]&&@tqta+=r.qta}
  @tb << ["TOTALE", "", @tqta]

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
  if (not @datispe.nil?) && @datispe.corriere == "GLS" && @anad.email.length > 0
    @datispe.note = "INVIO NOTIFICA: #{@anad.email}\n" + @datispe.note||""
  end
  unless @datispe.nil? || @datispe.note.nil? || @datispe.note.strip.length == 0
    #Esegue salto pagina se non è rimasto abbastanza spazio per le note
    pdf.start_new_page if pdf.cursor < 175
    
    pdf.text_box "Annotazioni: #{@datispe.note}",
                 :at => [2, 175], :width => 80, :height => 12, :size => 10, :style => :bold
    pdf.text_box "#{@datispe.note}",
                 :at => [70, 175], :width => 250, :height => 70, :size => 10
  end

	#Piede documento (aspetto - colli - um/valore - porto)
  #Esegue salto pagina se non è rimasto abbastanza spazio per i dati di piede
  pdf.start_new_page if pdf.cursor < 100

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
  pdf.draw_text @datispe&&@datispe.dtrit.strftime("%d/%m/%Y"),
                :at => [5, 27], :size => 10
  pdf.draw_text @datispe&&@datispe.orarit.strftime("%H:%M"),
                :at => [135, 27], :size => 10

	# spazio pe la firma
  pdf.draw_text "Firma",
                :at => [400, 40], :size => 10, :style => :bold

  #Numerazione delle pagine
  pdf.page_count.times do |page|
    pdf.go_to_page(page+1)
    pdf.draw_text "Pag. #{page+1} di #{pdf.page_count}",
                  :at => [480, 6], :size => 8
  end
