	pdf = Prawn::Document.new(:page_layout   => :portrait, 
                            :left_margin   => 1.2.cm, :right_margin  => 1.2.cm,
                            :top_margin    => 1.2.cm, :bottom_margin => 1.2.cm,
                            :page_size => 'A4')

	pdf.bounding_box [0,780], :width => 530, :height => 780 do
		pdf.stroke_bounds
	end

	pdf.bounding_box [0,780], :width => 240, :height => 130 do
		pdf.stroke_bounds
	end
  pdf.text_box "TEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE",
	             :at => [0,780], :width => 240, :size => 10, :height => 33, :center = true

	pdf.bounding_box [250,780], :width => 280, :height => 50 do
		pdf.stroke_bounds
	end

	pdf.bounding_box [270,725], :width => 260, :height => 75 do
		pdf.stroke_bounds
	end

	pdf.bounding_box [0,610], :width => 260, :height => 30 do
		pdf.stroke_bounds
	end

	pdf.bounding_box [0,560], :width => 260, :height => 50 do
		pdf.stroke_bounds
	end

	pdf.bounding_box [280,560], :width => 250, :height => 50 do
		pdf.stroke_bounds
	end

	pdf.bounding_box [0,500], :width => 530, :height => 320 do
		pdf.stroke_bounds
	end

	pdf.stroke_horizontal_rule

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

