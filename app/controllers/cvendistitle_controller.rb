class CvendistitleController < Ruport::Controller
  prepare :std_report
  stage :company_header, :Cvendistitle_header, :Cvendistitle_body, :Cvendistitle_footer
  finalize :std_report
end

include Helper_pdf
class CvendistitlePDF < CompanyPDFBase
  renders :pdf, :for => CvendistitleController

  build :Cvendistitle_header do
    options.text_format = { :font_size => 18, :justification => :center, :bold => true }
    
    add_text "VENDITE PER TITOLO E DISTRIBUTORE"
    pad(20) { hr }
    render_pdf
  end

  build :Cvendistitle_body do
    options.text_format = { :font_size => 14, :justification => :left }
    Article.titcvend(data).each do |art|
      desart = 'ARTICOLO: ' + art.codice + '    ' + art.descriz
      add_text desart
      Article.distit(art.id).each do |dis|
        desdis = 'DISTRIBUTORE: ' + dis.codice + ' ' + dis.denomin
        options.text_format = { :font_size => 14, :justification => :left } 
        options.table_format = {:width => 530, :bold_headings => true}
        table = buildtab(art.id, dis.id)
        draw_table(table, :title => desdis, :title_font_size => 14, :protect_rows => 4,
                   :column_options => {'Data_doc' => {:width => 80},
                                       'Numero' => {:width => 60},
                                       'Causale' => {:width => 250},
                                       'Carico' => {:width => 50, :justification => :right},
                                       'Vendite' => {:width => 50, :justification => :right},
                                       'Giac.' => {:width => 50, :justification => :right}
                                      })
        pad(20) { hr }
      end
    end
    render_pdf
  end

  build :Cvendistitle_footer do
    add_text " "
    add_text "FINE della PAGINA (ALEX)"
    render_pdf
  end

  def buildtab(art_id, dis_id)
    table = Ruport::Data::Table.new
    col_head = ["Data_doc", "Numero", "Causale", "Carico", "Vendite", "Giac."]
    giac = 0
    Article.vendtitdist(art_id, dis_id).each do |r|
      dt_doc = r.attributes["data_doc"]
      num = r.attributes["numero"]
      cau = r.attributes["causale"]
      mov = r.attributes["magcli"]
      magint = r.attributes["movmag"]
      qta = r.attributes["qta"]
      magint == "M" and mov == "C" ? car=qta  : car=""
      magint == "M" and mov == "S" ? car=-(qta.to_i) : car=car
      magint != "M"  and mov == "S" ? sca=qta  : sca=""
      magint != "M"  and mov == "C" ? sca=-(qta.to_i) : sca=sca
      giac = giac + car.to_i - sca.to_i
      table << Ruport::Data::Record.new([dt_doc, num, cau, car, sca, giac.to_s],
                                        :attributes => col_head)
    end
    table.column_names = col_head
    table
  end  
end
