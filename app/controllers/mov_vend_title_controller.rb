# coding: utf-8
class MovVendTitleController < Ruport::Controller
  prepare :std_report
  stage :company_header, :MovVendTitle_header, :MovVendTitle_body, :MovVendTitle_footer
  required_option :idanagen, :nrmag, :anarif, :grpmag, :azienda, :tp
  finalize :std_report
end

include Helper_pdf
class MovVendTitlePDF < CompanyPDFBase
  renders :pdf, :for => MovVendTitleController

  build :MovVendTitle_header do
    options.text_format = { :font_size => 18, :justification => :center, :bold => true }
    options.tp == 'M' ? add_text("MOVIMENTAZIONI PER TITOLO") : add_text("VENDITE PER TITOLO")
    pad(20) { hr }
    #render_pdf
  end

  build :MovVendTitle_body do
    options.text_format = { :font_size => 14, :justification => :left }
    data.each do |dataart|
      art = Article.find(dataart.attributes["artid"])
      desart = "ARTICOLO: #{art.codice}    #{art.descriz}"
      Tesdoc.anagen_mov_artic(art.id, options.idanagen, options.nrmag, options.anarif, options.tp).each do |tesdoc|
        if options.anarif == "S"
          idanagen = ""
        else
          idanagen = tesdoc.attributes["idanagen"]
          desanagen = "ANAGRAFICA: #{Anagen.find(idanagen).denomin}"
          add_text desanagen
        end
        Tesdoc.mag_mov_artic_anagen(art.id, idanagen, options.nrmag, options.anarif, options.grpmag, options.tp).each do |tesdoc|
          options.grpmag == "S" ? desmag = 'MAGAZZINI RAGGRUPPATI' : desmag = "MAGAZZINO: #{Anaind::NRMAG[tesdoc.attributes['nrmag'].to_i]}"
          add_text desart
          if options.tp == "M"
            add_text desmag
            pad(5) { hr }

            options.table_format = {:width => 530, :bold_headings => true}
            table = build_movtab(art.id, idanagen, tesdoc.attributes["nrmag"], options.anarif, options.grpmag)
            draw_table(table, :protect_rows => 4,
                       :column_options => {'Data_doc' => {:width => 60},
                                           'Numero'   => {:width => 53},
                                           'Causale'  => {:width => 210},
                                           'Mag.'     => {:width => 37, :justification => :right},
                                           'Car.'     => {:width => 35, :justification => :right},
                                           'Scar.'    => {:width => 37, :justification => :right},
                                           'Giac.'    => {:width => 37, :justification => :right},
                                           'Impe.'    => {:width => 40, :justification => :right},
                                           'Disp.'    => {:width => 37, :justification => :right}
                                           })
            pad(20) { hr }
          else
            pad(5) { hr }

            options.table_format = {:width => 530, :bold_headings => true}
            table = build_vendtab(art.id, idanagen, options.anarif)
            draw_table(table, :protect_rows => 4,
                       :column_options => {'Data_doc'  => {:width => 60},
                                           'Numero'    => {:width => 53},
                                           'Causale'   => {:width => 210},
                                           'Vendite'   => {:width => 55, :justification => :right},
                                           'Resi'      => {:width => 55, :justification => :right},
                                           'Differ.'   => {:width => 54, :justification => :right},
                                           'Progress.' => {:width => 60, :justification => :right},
                                           })
            pad(20) { hr }
          end
        end
      end
    end
    #render_pdf
  end

  build :MovVendTitle_footer do
    add_text " "
    #render_pdf
  end

  def build_vendtab(art_id, anagen_id, anarif)
    table = Ruport::Data::Table.new
    col_head = ["Data_doc", "Numero", "Causale", "Vendite", "Resi", "Differ.", "Progress."]
    prg  = 0
    tven = 0
    tres = 0
    Tesdoc.ven_artanagen(art_id, anagen_id, anarif).each do |r|
      dt_doc  = r.attributes["data_doc"]
      num     = r.attributes["numero"]
      cau     = r.attributes["causale"]
      tipomov = r.attributes["tipomov"]
      qta     = r.attributes["qta"].to_i
      (tipomov == "U" or tipomov == "V") ? ven=qta  : ven=""
      (tipomov == "E" or tipomov == "R") ? res=qta  : res=""
      prg  += ven.to_i - res.to_i
      tven += ven.to_i
      tres += res.to_i
      table << Ruport::Data::Record.new([dt_doc, num, cau, ven, res, ven.to_i - res.to_i, prg],
                                        :attributes => col_head)
    end
    table << Ruport::Data::Record.new(["TOTALI:", "", "", tven, tres, tven - tres, prg],
                                        :attributes => col_head)
    table.column_names = col_head
    table
  end  

  def build_movtab(art_id, anagen_id, nrmag, anarif, grpmag)
    table = Ruport::Data::Table.new
    col_head = ["Data_doc", "Numero", "Causale", "Mag.", "Car.", "Scar.", "Giac.", "Impe.", "Disp."]
    giac = 0
    tcar = 0
    tsca = 0
    timp = 0
    Tesdoc.mov_artanagenmag(art_id, anagen_id, nrmag, anarif, grpmag).each do |r|
      dt_doc  = r.attributes["data_doc"]
      num     = r.attributes["numero"]
      cau     = r.attributes["causale"]
      nrmag   = r.attributes["nrmag"]
      tipomov = r.attributes["tipomov"]
      qta     = r.attributes["qta"].to_i
      tpmag   = r.attributes["tipomag"]
      movmag  = r.attributes["movmag"]
      car, sca, imp = set_car_sca_imp(anarif, tipomov, tpmag, movmag, qta)
      giac += car.to_i - sca.to_i
      tcar += car.to_i
      tsca += sca.to_i
      timp += imp.to_i
      table << Ruport::Data::Record.new([dt_doc.strftime("%d/%m/%Y"), num, cau, nrmag, car, sca, giac.to_s, imp, giac-imp.to_i],
                                        :attributes => col_head)
    end
    table << Ruport::Data::Record.new(["TOTALI:", "", "", "", tcar, tsca, giac, timp, giac-timp],
                                        :attributes => col_head)
    table.column_names = col_head
    table
  end  
end
