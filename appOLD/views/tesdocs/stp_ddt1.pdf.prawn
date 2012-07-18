	pdf = Prawn::Document.new(:page_layout   => :portrait, 
                            :left_margin   => 1.2.cm, :right_margin  => 1.2.cm,
                            :top_margin    => 1.2.cm, :bottom_margin => 1.2.cm,
                            :page_size => 'A4')
	pdf.bounding_box [0,780], :width => 530, :height => 780 do
	# Cornice intero documento
		pdf.stroke_bounds
	end

	pdf.bounding_box [250,780], :width => 280, :height => 50 do
	# titolo documento
		pdf.stroke_bounds
	end
  pdf.text_box @tit_doc[0][:des],
	             :at => [250,770], :width => 280, :size => 12, :style => :bold, :align => :center
  pdf.text_box @tit_doc[1][:des],
	             :at => [250,760], :width => 280, :size => 8, :align => :center

	pdf.bounding_box [0,780], :width => 240, :height => 60 do
	# Mittente
		pdf.stroke_bounds
	end
  pdf.text_box @mitt[0][:des].upcase,
               :at => [0,770], :width => 240, :height => 20, :size => 12, :style => :bold
  pdf.text_box @mitt[1][:des],
               :at => [0,758], :width => 240, :height => 20, :size => 10
  pdf.text_box @mitt[2][:des],
               :at => [0,746], :width => 240, :height => 20, :size => 10


	pdf.bounding_box [0,710], :width => 240, :height => 70 do
	# Destinatario
		pdf.stroke_bounds
	end
  pdf.text_box @dest[0][:des].upcase,
               :at => [0,700], :width => 240, :height => 20, :size => 12, :style => :bold
  pdf.text_box @dest[1][:des],
               :at => [0,688], :width => 240, :height => 20, :size => 10
  pdf.text_box @dest[2][:des],
               :at => [0,676], :width => 240, :height => 20, :size => 10

	pdf.bounding_box [270,710], :width => 260, :height => 70 do
	# Luogo di destinazione
		pdf.stroke_bounds
	end

#  pdf.text_box "TEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE",
#	             :at => [0,780], :width => 240, :size => 10, :height => 33, :center => true



	pdf.bounding_box [0,635], :width => 260, :height => 30 do
	# Luogo di destinazione
		pdf.stroke_bounds
	end

	pdf.bounding_box [0,600], :width => 260, :height => 50 do
	# Causale di trasp
		pdf.stroke_bounds
	end

	pdf.bounding_box [280,600], :width => 250, :height => 50 do
	# Corriere
		pdf.stroke_bounds
	end

	pdf.bounding_box [0,545], :width => 530, :height => 360 do
	# Tabella articoli
		pdf.stroke_bounds
	end

	#pdf.stroke_horizontal_rule

	pdf.bounding_box [0,180], :width => 530, :height => 80 do
		pdf.stroke_bounds
	end

	pdf.bounding_box [0,100], :width => 530, :height => 50 do
		pdf.stroke_bounds
	end

	pdf.bounding_box [0,50], :width => 260, :height => 50 do
		pdf.stroke_bounds
	end

	pdf.bounding_box [300,50], :width => 230, :height => 30 do
		pdf.stroke_bounds
	end

