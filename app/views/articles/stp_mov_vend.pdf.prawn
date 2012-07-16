  @tp == "M" ? orient = :portrait : orient = :landscape
  pdf = Prawn::Document.new(:page_layout   => orient, 
                            :left_margin   => 1.2.cm, :right_margin  => 1.2.cm,
                            :top_margin    => 1.2.cm, :bottom_margin => 1.2.cm,
                            :page_size => 'A4')
  if @tp == "M"
    pdf.text "STAMPA MOVIMENTI DI MAGAZZINO", :size => 20, :style => :bold, :align => :center
  else
    pdf.text "STAMPA VENDITE ARTICOLO", :size => 20, :style => :bold, :align => :center
  end
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
          col_head = ["Data_doc", "Numero", "Causale", "Mag.", "Car.", "Scar.", "Giac.", "Impe.", "Disp."]
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
            car, sca, imp = set_car_sca_imp(@anarif, tipomov, tpmag, movmag, qta)
            giac += car.to_i - sca.to_i
            tcar += car.to_i
            tsca += sca.to_i
            timp += imp.to_i
            @tb << [dt_doc, num, cau, nrmag, car, sca, giac.to_s, imp, giac-imp.to_i]
          end
          @tb << ["TOTALI:", "", "", "", tcar, tsca, giac, timp, giac-timp]
          @tb.insert(0, col_head) # inserisco riga intestazione
        else
          col_head = ["Data_doc", "Numero", "Causale", "Vendite", "Resi", "Prezzo", "Fatturato", "Accreditato", "Progr."]
          prg  = 0
          tven = 0
          tres = 0
          tfatt = 0
          taccr = 0
          @tb = Array.new
          Tesdoc.ven_artanagen(art.id, @idanagen, @anarif).each do |r|
            dt_doc  = r.attributes["data_doc"]
            num     = r.attributes["numero"]
            cau     = r.attributes["causale"]
            tipomov = r.attributes["tipomov"]
            qta     = r.attributes["qta"].to_i
            prezzo  = r.attributes["prezzo"].to_f

            (tipomov == "U" or tipomov == "V") ? ven=qta : ven=""
            (tipomov == "E" or tipomov == "R") ? res=qta : res=""
            res == "" ? fatt = qta * prezzo : fatt = 0
            ven == "" ? accr = qta * prezzo : accr = 0
            prg  += ven.to_i - res.to_i
            tven += ven.to_i
            tres += res.to_i
            tfatt += fatt.to_f
            taccr += accr.to_f
           fatt = fatt.round(2).to_s
           fatt << "0" if fatt[fatt.length-2] == '.'
           accr = accr.round(2).to_s
           accr << "0" if accr[accr.length-2] == '.'
           prezzo = prezzo.round(2).to_s
           prezzo << "0" if prezzo[prezzo.length-2] == '.'
           fatt = "" if fatt == "0.00"
           accr = "" if accr == "0.00"
            @tb << [dt_doc, num, cau, ven, res, prezzo, fatt, accr, prg]
          end
          tfatt = tfatt.round(2).to_s
          tfatt << "0" if tfatt[tfatt.length-2] == '.' # 6.20 diventava 6.2, così rimane 6.20
          taccr = taccr.round(2).to_s
          taccr << "0" if taccr[taccr.length-2] == '.' # 6.20 diventava 6.2, così rimane 6.20
          @tb << ["TOTALI:", "", "", tven, tres, "", tfatt, taccr, prg]
          @tb.insert(0, col_head) # inserisco riga intestazione
        end
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


