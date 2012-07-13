  pdf = Prawn::Document.new(:page_layout   => :portrait, 
                            :left_margin   => 1.2.cm, :right_margin  => 1.2.cm,
                            :top_margin    => 1.2.cm, :bottom_margin => 1.2.cm,
                            :page_size => 'A4')
  @artmov.each do |dataart|
    art = Article.find(dataart.attributes["artid"])
    desart = 'ARTICOLO: ' + art.codice + '    ' + art.descriz
    Tesdoc.anagen_mov_artic(art.id, @idanagen, @nrmag, @anarif, @tp).each do |tesdoc|
      if @anarif == "S"
        idanagen = ""
      else
        idanagen = tesdoc.attributes["idanagen"]
        pdf.move_down 10
        desanagen = 'ANAGRAFICA: ' + Anagen.find(idanagen).denomin
        pdf.text desanagen,
                     :size => 12, :style => :bold, :align => :left
      end
      Tesdoc.mag_mov_artic_anagen(art.id, idanagen, @nrmag, @anarif, @grpmag, @tp).each do |tesdoc|
        @grpmag == "S" ? desmag = "MAGAZZINI RAGGRUPPATI" : desmag = "MAGAZZINO: #{Anaind::NRMAG[tesdoc.attributes['nrmag'].to_i]}"
        pdf.move_down 10
        pdf.text desart,
                     :size => 12, :style => :bold, :align => :left
        if @tp == "M"
          pdf.text desmag,
                       :size => 12, :style => :bold, :align => :left
          pdf.move_down 10
          @col_head = ["Data_doc", "Numero", "Causale", "Mag.", "Car.", "Scar.", "Giac.", "Impe.", "Disp."]
          giac = 0
          tcar = 0
          tsca = 0
          timp = 0
          @tb = Array.new
          Tesdoc.mov_artanagenmag(art.id, @idanagen, tesdoc.attributes["nrmag"], @anarif, @grpmag).each do |r|
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
            @tb << [dt_doc, num, cau, nrmag, car, sca, giac.to_s, imp, giac-imp.to_i]
          end
          @tb << ["TOTALI:", "", "", "", tcar, tsca, giac, timp, giac-timp]
          @tb.insert(0, @col_head) # inserisco riga intestazione

          pdf.table(@tb) do |tab|
            tab.row(0).font_style = :bold
            tab.row(tab.row_length-1).font_style = :bold
            tab.header = true
            tab.column(1).style :align => :right
            tab.column(3..8).style :align => :right
          end
        end
      end
    end
  end


