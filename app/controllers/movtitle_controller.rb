class MovtitleController < Ruport::Controller
  prepare :std_report
  stage :company_header, :Movtitle_header, :Movtitle_body, :Movtitle_footer
  required_option :idconto, :nrmag, :anarif, :grpmag
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
    data.each do |art|
      art = Article.find(art.attributes["artid"])
      desart = 'ARTICOLO: ' + art.codice + '    ' + art.descriz
      Tesdoc.conti_mov_artic(art.id, options.idconto, options.nrmag, options.anarif).each do |tesdoc|
        if options.anarif == "S"
          idconto = ""
        else
          idconto = tesdoc.attributes["idconto"]
          desconto = 'CONTO: ' + Conto.find(idconto).desest1
          add_text desconto
        end
        Tesdoc.mag_mov_artic_conto(art.id, idconto, options.nrmag, options.anarif, options.grpmag).each do |tesdoc|
          if options.grpmag == "S"
            desmag = 'MAGAZZINI RAGGRUPPATI'
          else
            desmag = 'MAGAZZINO: ' + Anaind::NRMAG[tesdoc.attributes['nrmag'].to_i]
          end
          add_text desart
          add_text desmag
          pad(5) { hr }

          options.table_format = {:width => 530, :bold_headings => true}
          table = buildtab(art.id, idconto, tesdoc.attributes["nrmag"], options.anarif, options.grpmag)
          draw_table(table, :protect_rows => 4,
                     :column_options => {'Data_doc' => {:width => 60},
                                         'Numero' => {:width => 53},
                                         'Causale' => {:width => 210},
                                         'Mag.' => {:width => 37, :justification => :right},
                                         'Car.' => {:width => 35, :justification => :right},
                                         'Scar.' => {:width => 37, :justification => :right},
                                         'Giac.' => {:width => 37, :justification => :right},
                                         'Impe.' => {:width => 40, :justification => :right},
                                         'Disp.' => {:width => 37, :justification => :right}
                                         })
          pad(20) { hr }
        end
      end
    end
    render_pdf
  end

  build :Movtitle_footer do
    add_text " "
    add_text "FINE della PAGINA (ALEX)"
    render_pdf
  end

  def buildtab(art_id, conto_id, nrmag, anarif, grpmag)
    table = Ruport::Data::Table.new
    col_head = ["Data_doc", "Numero", "Causale", "Mag.", "Car.", "Scar.", "Giac.", "Impe.", "Disp."]
    giac = 0
    tcar = 0
    tsca = 0
    timp = 0
    Tesdoc.mov_artcontomag(art_id, conto_id, nrmag, anarif, grpmag).each do |r|
      dt_doc = r.attributes["data_doc"]
      num = r.attributes["numero"]
      cau = r.attributes["causale"]
      nrmag = r.attributes["nrmag"]
      tipomov = r.attributes["tipomov"]
      qta = r.attributes["qta"].to_i
      tpmag = r.attributes["tipomag"]
      movmag = r.attributes["movmag"]
      if anarif == "S"
        tipomov == "E" and movmag == 'M'   ? car=qta  : car=""
        tipomov == "T" and tpmag  == 'DST' ? car=qta  : car=""
        tipomov == "U" and movmag == 'M'   ? sca=qta  : sca=""
        tipomov == "T" and tpmag  == 'SRC' ? sca=qta  : sca=""
        tipomov == "E" and movmag == 'I'   ? imp= qta : imp=""
        tipomov == "U" and movmag == 'I'   ? imp=-qta : imp=""
      else
        tipomov == "E" and movmag == 'M'   ? sca=qta  : sca=""
        tipomov == "V" and tpmag  == 'SRC' ? sca=qta  : sca=""
        tipomov == "U" and movmag == 'M'   ? car=qta  : car=""
        tipomov == "R" and tpmag  == 'DST' ? car=qta  : car=""
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
    table << Ruport::Data::Record.new(["TOTALI:", "", "", "", tcar, tsca, giac, timp, giac-timp],
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
