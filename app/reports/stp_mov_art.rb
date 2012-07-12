class StpMovArt < Prawn::Document
  attr_accessor :artmov, :anarif, :nrmag, :tp, :id, :idanagen, :grpmag #, :righe, :colonne, :column_gutter, :gutter, :omaggi
  
  def to_pdf
    @artmov.each do |dataart|
      art = Article.find(dataart.attributes["artid"])
      desart = 'ARTICOLO: ' + art.codice + '    ' + art.descriz
      Tesdoc.anagen_mov_artic(art.id, @idanagen, @nrmag, @anarif, @tp).each do |tesdoc|
        @anarif == "S" ? idanagen = "" : pdf.text desana(idanagen), :size => 12, :style => :bold, :align => :left
        if @anarif == "S"
          idanagen = ""
        else
          idanagen = tesdoc.attributes["idanagen"]
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
              if @anarif == "S"
                tipomov == "E" and movmag == 'M'   ? car=qta  : car=""
                tipomov == "T" and tpmag  == 'DST' ? car=qta  : car=""
                tipomov == "U" and movmag == 'M'   ? sca=qta  : sca=""
                tipomov == "T" and tpmag  == 'SRC' ? sca=qta  : sca=""
              else
                tipomov == "U" and movmag == 'M'   ? car=qta  : car=""
                tipomov == "R" and tpmag  == 'DST' ? car=qta  : car=""
                tipomov == "E" and movmag == 'M'   ? sca=qta  : sca=""
                tipomov == "V" and tpmag  == 'SRC' ? sca=qta  : sca=""
              end
              tipomov == "E" and movmag == 'I' ? imp=-qta : imp=""
              tipomov == "U" and movmag == 'I' ? imp=-qta : imp=""
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
            end

          end
        end
      end
    end
  end


  def to_pdf
    pagine = (@dataset.size / 24).ceil + 1
    @dataset.sort! { |a,b| a.zip <=> b.zip } # in ordine di cap
    conta = 0
    pagine.times do |pagina|
      define_grid(:columns => @colonne, :rows => @righe, :column_gutter => @column_gutter, :gutter => @gutter)
      @righe.times do |riga|        
        @colonne.times do |colonna|
          b = grid(riga, colonna)
          if conta < @dataset.size
            bounding_box b.top_left, :width => b.width, :height => b.height do
              prov = @dataset[conta].province ? "(%s)"%[@dataset[conta].province] : ''
              text "%s\n%s\n%s %s %s"%[@dataset[conta].full_name,@dataset[conta].address,@dataset[conta].zip,@dataset[conta].city,prov]
              if @omaggi
                omaggio = @dataset[conta].has_type_programmato?(2)
                text "%s"%[omaggio.description.slice(0,20)] if omaggio                
              end
              text "PIEGO DI LIBRI",:style => :bold
            end        
          end
          conta += 1
        end
      end
      start_new_page unless pagina == pagine - 1
    end
    render
  end
end
