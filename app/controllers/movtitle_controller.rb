class MovtitleController < Ruport::Controller
  prepare :std_report
  stage :company_header, :Movtitle_header, :Movtitle_body, :Movtitle_footer
  finalize :std_report
end

include Helper_pdf
class MovtitlePDF < CompanyPDFBase
  renders :pdf, :for => MovtitleController

  build :Movtitle_header do
    options.text_format = { :font_size => 18, :justification => :center, :bold => true }
    
    add_text "MOVIMENTAZIONI PER TITOLO"
    pad(20) { hr }
    render_pdf
  end

  build :Movtitle_body do
    options.text_format = { :font_size => 14, :justification => :left }
    Article.movimentati(data).each do |art|
      des = 'ARTICOLO: ' + art.codice + '    ' + art.descriz
      options.table_format = {:width => 530, :bold_headings => true}
      table = buildtab(art.id)
      draw_table(table, :title => des, :title_font_size => 14, :protect_rows => 4,
                 :column_options => {'Data_doc' => {:width => 80},
                                     'Numero' => {:width => 60},
                                     'Causale' => {:width => 210},
                                     'Car.' => {:width => 40, :justification => :right},
                                     'Scar.' => {:width => 40, :justification => :right},
                                     'Giac.' => {:width => 40, :justification => :right},
                                     'Impe.' => {:width => 40, :justification => :right},
                                     'Disp.' => {:width => 40, :justification => :right}
                                     })
      pad(20) { hr }
    end
    render_pdf
  end

  build :Movtitle_footer do
    add_text " "
    add_text "FINE della PAGINA (ALEX)"
    render_pdf
  end

  def buildtab(id)
    table = Ruport::Data::Table.new
    col_head = ["Data_doc", "Numero", "Causale", "Car.", "Scar.", "Giac.", "Impe.", "Disp."]
    giac = 0
    tcar = 0
    tsca = 0
    timp = 0
    Article.movmag(id).each do |r|
      dt_doc = r.attributes["data_doc"]
      num = r.attributes["numero"]
      cau = r.attributes["causale"]
      mov = r.attributes["mov"]
      qta = r.attributes["qta"]
      mag = r.attributes["mag"]
      mov == "E" and mag == 'M' ? car=qta : car=""
      mov == "U" and mag == 'M' ? sca=qta : sca=""
      mov == "E" and mag == 'I' ? imp=-qta : imp=""
      mov == "U" and mag == 'I' ? imp= qta : imp=""
      giac += car.to_i - sca.to_i
      tcar += car.to_i
      tsca += sca.to_i
      timp += imp.to_i
      table << Ruport::Data::Record.new([dt_doc, num, cau, car, sca, giac.to_s, imp, giac-imp.to_i],
                                        :attributes => col_head)
    end
    table << Ruport::Data::Record.new(["TOTALI:", "", "", tcar, tsca, giac, timp, giac-timp],
                                        :attributes => col_head)
    table.column_names = col_head
    table
  end  
end
