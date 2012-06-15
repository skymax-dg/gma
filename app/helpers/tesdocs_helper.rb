module TesdocsHelper

  def init_filter
    @clifilter = "C"
    @forfilter = "F"
    @altfilter = "A"
    @causmags = Causmag.find(:all, :conditions => ["tipo_doc = :tpd and azienda = :azd", {:tpd => se_tipo_doc, :azd => StaticData::AZIENDA}])
    @contos = Conto.find4docfilter([@clifilter, @forfilter, @altfilter], @tpfilter||"", @desfilter||"")
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
    if (causmag.tipo == "E" and tp == "S") or (causmag.tipo == "U" and tp == "D")
      mags = conto.magsavailable([0])
    else
      mags = Anagen.find(StaticData::ANARIF).magsavailable([0])
    end
  end
  
  def lastprgrig
    return self.rigdocs.last.prgrig unless self.rigdocs.empty?
    return 0
  end
end
