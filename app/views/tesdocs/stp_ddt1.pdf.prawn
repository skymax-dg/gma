	pdf = Prawn::Document.new(:page_layout   => :portrait, 
                            :left_margin   => 1.2.cm, :right_margin  => 1.2.cm,
                            :top_margin    => 1.2.cm, :bottom_margin => 1.2.cm,
                            :page_size => 'A4')
	pdf.bounding_box [0,780], :width => 530, :height => 780 do
	# Cornice intero documento
#		pdf.stroke_bounds
	end

	pdf.bounding_box [240,780], :width => 290, :height => 50 do
	# titolo documento
		pdf.stroke_bounds
	end
  pdf.text_box @tit_doc[0],
	             :at => [250,770], :width => 280, :size => 12, :style => :bold, :align => :center
  pdf.text_box @tit_doc[1],
	             :at => [250,760], :width => 280, :size => 8, :align => :center

	pdf.bounding_box [0,780], :width => 240, :height => 50 do
	# Mittente
		pdf.stroke_bounds
	end
  pdf.text_box @ana.denomin.upcase,
               :at => [0,770], :width => 240, :height => 20, :size => 12, :style => :bold
  pdf.text_box @sl[:indir],
               :at => [0,758], :width => 240, :height => 20, :size => 10
  pdf.text_box "#{@sl[:cap]} #{@sl[:desloc]}",
               :at => [0,746], :width => 240, :height => 20, :size => 10


	pdf.bounding_box [0,710], :width => 240, :height => 70 do
	# Destinatario
#		pdf.stroke_bounds
	end
    pdf.text_box @anad.denomin.upcase,
                 :at => [0,700], :width => 240, :height => 20, :size => 12, :style => :bold
    pdf.text_box @sld[:indir],
                 :at => [0,688], :width => 240, :height => 20, :size => 10
    pdf.text_box "#{@sld[:cap]} #{@sld[:desloc]}",
                 :at => [0,676], :width => 240, :height => 20, :size => 10

	pdf.bounding_box [270,725], :width => 260, :height => 85 do
	# Luogo di destinazione
#		pdf.stroke_bounds
	end

	unless @datispe.nil?
	  pdf.text_box "Luogo di destinazione",
	               :at => [270, 720], :width => 240, :height => 20, :size => 12
	  pdf.text_box @datispe.presso.upcase,
	               :at => [285, 695], :width => 240, :height => 20, :size => 12, :style => :bold
#	  pdf.text_box @datispe.dest1,
#	               :at => [285, 683], :width => 240, :height => 40, :size => 10
#	  pdf.text_box @datispe.dest2,
#	               :at => [285, 671], :width => 240, :height => 20, :size => 10
	  pdf.text_box "#{@datispe.dest1} #{@datispe.dest2}",
	               :at => [285, 683], :width => 240, :height => 60, :size => 10
	end


  pdf.bounding_box [0,730], :width => 530, :height => 100 do
  # Anagrafica e luogo di destinazione
    pdf.stroke_bounds
  end

	pdf.bounding_box [0,630], :width => 530, :height => 60 do
	# Riferimenti documento e causale/corriere
		pdf.stroke_bounds
	end
    pdf.text_box "Documento Nr. #{@rifdoc[:nr]} del #{@rifdoc[:dt]}",
                 :at => [0, 620], :width => 240, :height => 20, :size => 10

	pdf.bounding_box [0,600], :width => 260, :height => 50 do
	# Causale di trasp
#		pdf.stroke_bounds
	end
    pdf.text_box "Causale di trasporto: #{Spediz::CAUSTRA[@datispe.caustra]}",
                 :at => [0, 590], :width => 240, :height => 20, :size => 10

	pdf.bounding_box [280,600], :width => 250, :height => 50 do
	# Corriere
#		pdf.stroke_bounds
	end
    pdf.text_box "A mezzo: #{Spediz::CORRIERE[@datispe.corriere]}",
                 :at => [270, 590], :width => 260, :height => 45, :size => 10

  #pdf.bounding_box [0,545], :width => 530, :height => 360 do
  pdf.bounding_box [0,545], :width => 530, :height => 1 do
	# Tabella articoli
#		pdf.stroke_bounds
  end
  @tb = Array.new
  @tb << ["Q.ta'", "Descrizione"]
  @tesdoc.rigdocs.each {|r|@tb<<[r.qta, r.descriz]}
@tb<<[1, "descriz"]
@tb<<[1, "descriz"]
@tb<<[1, "descriz"]
@tb<<[1, "descriz"]
@tb<<[1, "descriz"]
@tb<<[1, "descriz"]
@tb<<[1, "descriz"]
@tb<<[1, "descriz"]
@tb<<[1, "descriz"]
@tb<<[1, "descriz"]
@tb<<[1, "descriz"]
@tb<<[1, "descriz"]

  tab = pdf.make_table(@tb)
  tab.row(0).font_style = :bold
  #tab.row(tab.row_length-1).font_style = :bold
  tab.header = true
  tab.column(0).style :align => :right
  tab.column(1).style :align => :left
  tab.draw
  pdf.start_new_page if pdf.cursor < 100 or (pdf.cursor < 175 and not(@datispe.note.nil?) and @datispe.note.strip.length > 0)
	#pdf.stroke_horizontal_rule

	# note
	pdf.bounding_box [0,180], :width => 530, :height => 80 do
#		pdf.stroke_bounds
	end
  unless (@datispe.note.nil? or @datispe.note.strip.length == 0)
    pdf.text_box "Annotazioni: #{@datispe.note}",
                 :at => [0, 175], :width => 80, :height => 12, :size => 10, :style => :bold
    pdf.text_box "#{@datispe.note}",
                 :at => [70, 175], :width => 250, :height => 70, :size => 10
  end

	# dati di piede (aspetto - colli - um/valore - porto)
	pdf.bounding_box [0,100], :width => 530, :height => 50 do
		pdf.stroke_bounds
	end
    pdf.text_box "Aspetto esteriore dei beni",
                 :at => [0, 98], :height => 12, :size => 10, :style => :bold
    pdf.text_box "Nr.Colli",
                 :at => [200, 98], :height => 12, :size => 10, :style => :bold
    pdf.text_box "#{@datispe.um}",
                 :at => [300, 98], :height => 12, :size => 10, :style => :bold
    pdf.text_box "Porto",
                 :at => [400, 98], :height => 12, :size => 10, :style => :bold
    pdf.text_box Spediz::ASPETTO[@datispe.aspetto],
                 :at => [0, 85], :width => 190, :height => 12, :size => 10
    pdf.text_box @datispe.nrcolli.to_s,
                 :at => [200, 85], :width => 95, :height => 12, :size => 10
    pdf.text_box @datispe.valore.to_s,
                 :at => [300, 85], :width => 95, :height => 12, :size => 10
    pdf.text_box Spediz::PORTO[@datispe.porto],
                 :at => [400, 85], :width => 125, :height => 12, :size => 10

	# data e ora ritiro
	pdf.bounding_box [0,50], :width => 530, :height => 50 do
		pdf.stroke_bounds
	end
    pdf.text_box "Data del ritiro",
                 :at => [0, 48], :width => 125, :height => 12, :size => 10, :style => :bold
    pdf.text_box "Ora del ritiro",
                 :at => [130, 48], :width => 125, :height => 12, :size => 10, :style => :bold
    pdf.text_box @datispe.dtrit.strftime("%d/%m/%Y"),
                 :at => [5, 35], :width => 115, :height => 12, :size => 10
    pdf.text_box @datispe.orarit.strftime("%H:%M"),
                 :at => [135, 35], :width => 115, :height => 12, :size => 10

	# spazio pe la firma
	# pdf.bounding_box [300,50], :width => 230, :height => 30 do
	#	 pdf.stroke_bounds
	# end
    pdf.text_box "Firma",
                 :at => [400, 48], :width => 115, :height => 12, :size => 10, :style => :bold
