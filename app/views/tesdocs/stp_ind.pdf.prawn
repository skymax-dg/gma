pdf = Prawn::Document.new(:page_layout   => :portrait, 
                          :left_margin   => 1.2.cm, :right_margin  => 1.2.cm,
                          :top_margin    => 1.2.cm, :bottom_margin => 1.2.cm,
                          :page_size => 'A4')
nr = 1
while nr <= @copie do
  pdf.text_box "Luogo di consegna",
               :at => [45, 750], :height => 25, :size => 24, :style => :bold
  pdf.formatted_text_box [{:text => "Presso: #{@presso.upcase}\n", :styles => [:bold], :size => 20},
                          {:text => "#{@ind1}\n#{@ind2}\n", :size => 20},
                          {:text => "Telefono: #{@riftel}", :styles => [:bold], :size => 20}
                          ],
                         :at => [60,715], :width => 500, :height => 200,
                         :overflow => :shrink_to_fit, :size => 20, :min_font_size => 12
  #Numerazione colli
  pdf.draw_text "COLLO #{nr} di #{@copie}",
                :at=>[45, 500], :styles=>[:bold], :size=>20 if @nrcopie == 'S'

  nr += 1
  if nr <= @copie
    pdf.text_box "Luogo di consegna",
                 :at => [45, 320], :height => 25, :size => 24, :style => :bold
    pdf.formatted_text_box [{:text => "Presso: #{@presso.upcase}\n", :styles => [:bold], :size => 20},
                            {:text => "#{@ind1}\n#{@ind2}\n", :size => 20},
                            {:text => "Telefono: #{@riftel}", :styles => [:bold], :size => 20}
                            ],
                           :at => [60,285], :width => 500, :height => 200,
                           :overflow => :shrink_to_fit, :size => 20, :min_font_size => 12
    #Numerazione colli
    pdf.draw_text "COLLO #{nr} di #{@copie}",
                  :at=>[45, 70], :styles=>[:bold], :size=>20 if @nrcopie == 'S'
    nr += 1
  end

  #Salto pagina
  pdf.start_new_page(:page_layout   => :portrait, 
                     :left_margin   => 1.2.cm, :right_margin  => 1.2.cm,
                     :top_margin    => 1.2.cm, :bottom_margin => 1.2.cm,
                     :page_size => 'A4') if nr <= @copie
end