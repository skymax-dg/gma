ppdf.bounding_box [0,80], :width => 530, :height => 30 do
  ppdf.stroke_bounds
end
ppdf.draw_text "Aspetto esteriore dei beni",
               :at => [2, 70], :size => 10, :style => :bold
ppdf.draw_text "Nr.Colli",
               :at => [200, 70], :size => 10, :style => :bold
ppdf.draw_text "#{@datispe&&@datispe.um}",
               :at => [300, 70], :size => 10, :style => :bold
ppdf.draw_text "Porto",
               :at => [400, 70], :size => 10, :style => :bold
ppdf.draw_text Spediz::ASPETTO[(@datispe&&@datispe.aspetto)||""]||"",
               :at => [2, 57], :size => 10
ppdf.draw_text @datispe&&@datispe.nrcolli.to_s,
               :at => [200, 57], :size => 10
ppdf.draw_text @datispe&&@datispe.valore.to_s,
               :at => [300, 57], :size => 10
ppdf.draw_text Spediz::PORTO[(@datispe&&@datispe.porto)]||"",
               :at => [400, 57], :size => 10
# data e ora ritiro
ppdf.bounding_box [0,50], :width => 530, :height => 35 do
  ppdf.stroke_bounds
end
ppdf.draw_text "Data del ritiro",
               :at => [2, 40], :size => 10, :style => :bold
ppdf.draw_text "Ora del ritiro",
               :at => [130, 40], :size => 10, :style => :bold
ppdf.draw_text @datispe&&@datispe.dtrit&&@datispe.dtrit.strftime("%d/%m/%Y"),
               :at => [5, 27], :size => 10
ppdf.draw_text @datispe&&@datispe.orarit&&@datispe.orarit.strftime("%H:%M"),
               :at => [135, 27], :size => 10 if @datispe&&@datispe.aspetto
# spazio pe la firma
ppdf.draw_text "Firma",
               :at => [400, 40], :size => 10, :style => :bold
