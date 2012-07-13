module TesdocsHelper
  def init_filter(azienda)
    @clifilter = "C"
    @forfilter = "F"
    @altfilter = "A"
    @causmags = Causmag.find(:all, :conditions => ["tipo_doc = :tpd and azienda = :azd", {:tpd => se_tipo_doc, :azd => current_user.azienda}])
    @contos = Conto.find4docfilter([@clifilter, @forfilter, @altfilter], @tpfilter||"", @desfilter||"", current_user.azienda, current_annoese)
#    render "index"
  end

  def store_tipo_doc (td)
    session[:se_tipo_doc] = td unless td.nil?
  end
    
  def se_tipo_doc
    session[:se_tipo_doc]
  end
  
  def clear_tipo_doc
    session[:se_tipo_doc] = nil
  end

  def findmags(tp, idcausmag, idconto)
    # tp = "S x magsrc(origine) - "D" x magdst(destinazione)
    # Inizializzo mags con il magazzino 0 (nessun magazzino)
    # mags = Hash[*Anaind::NRMAG.select{|k,v| [0].index(k)}.flatten]
    causmag = Causmag.find(idcausmag)
    conto = Conto.find(idconto)
    # Se il movimento è di entrata/rend.resi il mag sorgente è uno tra quelli del conto
    # Se il movimento è di uscita/rend.vendite il mag destinazione è uno tra quelli del conto
    if (["E","V"].include?(causmag.tipo) and tp == "S") or (["U","R"].include?(causmag.tipo) and tp == "D")
      mags = conto.magsavailable([0])
    elsif (["E","T"].include?(causmag.tipo) and tp == "D") or (["U","T"].include?(causmag.tipo) and tp == "S")
      mags = Anagen.find(current_user.azienda).magsavailable([0])
    else
      # Inizializzo mags con il magazzino 0 (nessun magazzino)
      mags = Hash[*Anaind::NRMAG.select{|k,v| [0].index(k)}.flatten]
      # Errore
    end
  end

  def set_car_sca_imp(anarif, tipomov, tpmag, movmag, qta)
    if movmag == 'M'
      if anarif == "S"
        tipomov == "E" and tpmag  == 'DST' ? car=qta  : car="" # Movim. in entrata = carico mag. azienda (DST)
        tipomov == "U" and tpmag  == 'SRC' ? sca=qta  : sca="" # Movim. in uscita = scarico mag. azienda (SRC)
        tipomov == "T" and tpmag  == 'SRC' ? sca=qta  : sca="" # Trasferimento = scarico mag. azienda (SRC)
        tipomov == "T" and tpmag  == 'DST' ? car=qta  : car="" # Trasferimento = carico mag. azienda (DST)
      else
        tipomov == "E" and tpmag  == 'SRC' ? sca=qta  : sca=""
        tipomov == "U" and tpmag  == 'DST' ? car=qta  : car=""
        tipomov == "V" and tpmag  == 'SRC' ? sca=qta  : sca=""
        tipomov == "R" and tpmag  == 'DST' ? car=qta  : car=""
      end
    elsif movmag = 'I'
      tipomov == "E" and tpmag  == 'DST' ? imp= qta : imp="" # Ordine ricevuto = impegno mag. azienda (DST)
      tipomov == "U" and tpmag  == 'SRC' ? imp=-qta : imp="" # Ordine cancellato = disimpegno mag. azienda (DST)
    else
      errore
    end
    return car, sca, imp
  end
 
end
