class MovtitleController < Ruport::Controller
  prepare :std_report
  stage :company_header, :Movtitle_header, :Movtitle_body, :Movtitle_footer
  required_option :idconto, :nrmag, :anarif, :groupmag
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
    data.each do |idart|
      art = Article.find(idart)
      desart = 'ARTICOLO: ' + art.codice + '    ' + art.descriz
      add_text desart
#      if options.anarif == "S"
#      else
        Tesdoc.conti_mov_artic(art.id, options.idconto, options.nrmag, options.anarif).each do |idconto|
bbb         
if options.anarif == "S"
idconto = ""
else
          desconto = 'CONTO: ' + Conto.find(idconto).desest1
          add_text desconto
end
 ppp         
          if options.groupmag == "S"
          else
            Tesdoc.mag_mov_artic_conto(art.id, idconto, options.nrmag, options.anarif).each do |nrmag|
              desmag = 'MAGAZZINO: ' + Tesdoc::NRMAG[nrmag]
              add_text desmag

              options.table_format = {:width => 530, :bold_headings => true}
              table = buildtab(art.id, idconto, nrmag, options.anarif)
              draw_table(table, :title => des, :title_font_size => 14, :protect_rows => 4,
                         :column_options => {'Data_doc' => {:width => 80},
                                             'Numero' => {:width => 60},
                                             'Causale' => {:width => 210},
                                             'Mag.' => {:width => 40, :justification => :right},
                                             'Car.' => {:width => 40, :justification => :right},
                                             'Scar.' => {:width => 40, :justification => :right},
                                             'Giac.' => {:width => 40, :justification => :right},
                                             'Impe.' => {:width => 40, :justification => :right},
                                             'Disp.' => {:width => 40, :justification => :right}
                                             })
              pad(20) { hr }
            end
          end
#        end
      end
    end
    render_pdf
  end

  build :Movtitle_footer do
    add_text " "
    add_text "FINE della PAGINA (ALEX)"
    render_pdf
  end

  def buildtab(art_id, conto_id, nrmag, anarif)
    table = Ruport::Data::Table.new
    col_head = ["Data_doc", "Numero", "Causale", "Mag", "Car.", "Scar.", "Giac.", "Impe.", "Disp."]
    giac = 0
    tcar = 0
    tsca = 0
    timp = 0
    Tesdoc.conti_mov_artic(art_id, conto_id, nrmag, anarif).each do |r|
      dt_doc = r.attributes["data_doc"]
      num = r.attributes["numero"]
      cau = r.attributes["causale"]
      nrmag = r.attributes["nrmag"]
      tipomov = r.attributes["tipomov"]
      qta = r.attributes["qta"]
      tpmag = r.attributes["tipomag"]
      movmag = r.attributes["movmag"]
      if anarif == "S"
        tipomov == "E" and movmag == 'M'   ? car=qta : car=""
        tipomov == "T" and tpmag  == 'DST' ? car=qta : car=""
        tipomov == "U" and movmag == 'M'   ? sca=qta : sca=""
        tipomov == "T" and tpmag  == 'SRC' ? sca=qta : sca=""
        tipomov == "E" and movmag == 'I'   ? imp= qta : imp=""
        tipomov == "U" and movmag == 'I'   ? imp=-qta : imp=""
      else
        tipomov == "E" and movmag == 'M'   ? sca=qta : sca=""
        tipomov == "V" and tpmag  == 'SRC' ? sca=qta : sca=""
        tipomov == "U" and movmag == 'M'   ? car=qta : car=""
        tipomov == "R" and tpmag  == 'DST' ? car=qta : car=""
        tipomov == "E" and movmag == 'I'   ? imp=-qta : imp=""
        tipomov == "U" and movmag == 'I'   ? imp= qta : imp=""
      end
      giac += car.to_i - sca.to_i
      tcar += car.to_i
      tsca += sca.to_i
      timp += imp.to_i
      table << Ruport::Data::Record.new([dt_doc, num, cau, nrmag, car, sca, giac.to_s, imp, giac-imp.to_i],
                                        :attributes => col_head)
    end
    table << Ruport::Data::Record.new(["TOTALI:", "", "", tcar, tsca, giac, timp, giac-timp],
                                        :attributes => col_head)
    table.column_names = col_head
    table
  end  

  def buildtabOLD(id)
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
