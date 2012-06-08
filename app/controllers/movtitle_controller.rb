class MovtitleController < Ruport::Controller
  stage :mov_header, :mov_body, :mov_footer

  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => MovtitleController
    build :mov_header do
      pdf_writer.select_font("Times-Roman") 
      options.text_format = { :font_size => 14, :justification => :right } 
      add_text "<i>" + Anagen.find(StaticData::ANARIF).denomin + "</i>" 
      add_text "Creato alle #{Time.now.strftime('%H:%M del %d-%m-%Y')}" 
#    center_image_in_box "ruport.png", :x => left_boundary,  
#                                      :y => top_boundary - 50, 
#                                      :width => 275, 
#                                      :height => 70 
      move_cursor_to top_boundary - 80 
#      pad_bottom(20) { hr } 
      options.text_format = { :font_size => 18, :justification => :center, :bold => true }
      
      add_text "MOVIMENTAZIONI PER TITOLO"
      pad(20) { hr }
      render_pdf
    end

    build :mov_body do
      options.text_format = { :font_size => 14, :justification => :left }
      Article.movimentati(data).each do |art|
        des = 'ARTICOLO: ' + art.codice + '    ' + art.descriz
#        pad_bottom(25) { add_text(des)}
        options.table_format = {:width => 530, :bold_headings => true}
        table = buildtab(art.id)
        draw_table(table, :title => des, :title_font_size => 14, :protect_rows => 4,
                   :column_options => {'Data_doc' => {:width => 80},
                                       'Numero' => {:width => 60},
                                       'Causale' => {:width => 250},
                                       'Carico' => {:width => 50, :justification => :right},
                                       'Scar.' => {:width => 50, :justification => :right},
                                       'Giac.' => {:width => 50, :justification => :right}
                                       })
        pad(20) { hr }
      end
      render_pdf
    end

    build :mov_footer do
      add_text " "
      add_text "FINE della PAGINA (ALEX)"
      render_pdf
    end

    def buildtab(id)
      table = Ruport::Data::Table.new
      col_head = ["Data_doc", "Numero", "Causale", "Carico", "Scar.", "Giac."]
      giac = 0
      Article.movmag(id).each do |r|
        dt_doc = r.attributes["data_doc"]
        num = r.attributes["numero"]
        cau = r.attributes["causale"]
        mov = r.attributes["mov"]
        qta = r.attributes["qta"]
        mov == "E" ? car=qta : car=""
        mov == "U" ? sca=qta : sca=""
        giac = giac + car.to_i - sca.to_i
        table << Ruport::Data::Record.new([dt_doc, num, cau, car, sca, giac.to_s],
                                          :attributes => col_head)
      end
      table.column_names = col_head
      table
    end  
  end
end
