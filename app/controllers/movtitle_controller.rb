class MovtitleController < Ruport::Controller
  stage :mov_header, :mov_body, :mov_footer
  
  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => MovtitleController
    
    build :mov_header do
      options.text_format = { :font_size => 18, :justification => :center, :bold => true }
      add_text "MOVIMENTAZIONI PER TITOLO"
      pad(20) { hr }
      render_pdf
    end

    build :mov_body do
      options.text_format = { :font_size => 14, :justification => :left }
      Article.movimentati.each do |art|
        des = 'ARTICOLO: ' + art.codice + '    ' + art.descriz
        pad_bottom(15) { add_text(des)}
        options.table_format = {:width => 530, :bold_headings => true}
        table = Article.movmag(art.id)
        draw_table(table,
                   :column_options => {'Data_doc' => {:width => 80},
                                       'Numero' => {:width => 60},
                                       'Causale' => {:width => 250},
                                       'Carico' => {:width => 50},
                                       'Scar.' => {:width => 50},
                                       'Giac.' => {:width => 50}
                                       })
        pad(20) { hr }
      end
      render_pdf
    end

    build :mov_footer do
      add_text " "
      add_text "FOOTER della PAGINA (ALEX)"
      render_pdf
    end
  end
end
