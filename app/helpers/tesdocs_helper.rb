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
    if (["E","R"].include?(causmag.tipo) and tp == "S") or (["U","V"].include?(causmag.tipo) and tp == "D")
      mags = conto.magsavailable([0])
    elsif (["E","R"].include?(causmag.tipo) and tp == "D") or (["U","V"].include?(causmag.tipo) and tp == "S")
      mags = Anagen.find(current_user.azienda).magsavailable([0])
    else
      Errore
    end
  end
  
end
