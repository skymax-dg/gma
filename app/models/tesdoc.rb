class Tesdoc < ActiveRecord::Base
  belongs_to :causmag
  belongs_to :conto
  has_many :rigdocs, :dependent => :destroy

  attr_accessible :azienda, :annoese, :tipo_doc, :num_doc, :data_doc, :descriz,
                  :causmag_id, :nrmagsrc, :nrmagdst, :seguefatt, :conto_id, :sconto

  validates :azienda, :annoese, :tipo_doc, :num_doc, :data_doc, :descriz,
            :causmag_id, :conto_id, :nrmagsrc, :nrmagdst, :seguefatt, :sconto, :presence => true
  validates :descriz,  :length => { :maximum => 150}

  NRMAG = $ParAzienda['ANAIND']['NRMAG']
  SEGUEFATT = $ParAzienda['TESDOC']['SEGUEFATT']
  TIPO_DOC = $ParAzienda['CAUSMAG']['TIPO_DOC']

  def rigdocbyxls(xls, wks, rownr, hshcol)
    success = []
    errors = []
    prgrig = 1
    prgrig = self.rigdocs.last.prgrig + 1 unless self.rigdocs.empty?
    xls.worksheet(wks).each rownr do |row|
      unless row[hshcol[:article_id]].blank?
        @rigdoc = self.rigdocs.build # La Build valorizza automaticamente il campo rigdoc.tesdoc_id
        @rigdoc.article_id = Article.find_by_codice(row[hshcol[:article_id]].to_s.strip).id
        @rigdoc.descriz = Article.find_by_codice(row[hshcol[:article_id]].to_s.strip).descriz
        @rigdoc.qta = row[hshcol[:qta]]
        @rigdoc.prezzo = row[hshcol[:prezzo]]
        @rigdoc.sconto = row[hshcol[:sconto]]
        @rigdoc.prgrig = prgrig
        if @rigdoc.save
          prgrig += 1
          success << "Caricato articolo:" + row[hshcol[:article_id]].to_s.strip + " " + @rigdoc.descriz +
                     " qta:" + @rigdoc.qta.to_s + " prezzo:" + @rigdoc.prezzo.to_s + " sconto:" + @rigdoc.sconto.to_s
        else
          errors << "Articolo:" + row[hshcol[:article_id]].to_s.strip + " " + @rigdoc.descriz +
                    " qta:" + @rigdoc.qta.to_s + " prezzo:" + @rigdoc.prezzo.to_s + " sconto:" + @rigdoc.sconto.to_s
        end
      end
    end
    return errors, success
  end

  def self.filter (tp, des, tpc, tipo_doc, causmag, conto, page)
    hsh = {"RS" => "denomin", "CF" => "codfis", "PI" => "pariva"}
    hshvar = Hash.new

    whcausmag = "causmags.tipo_doc = :tipo_doc"
    hshvar[:tipo_doc] = tipo_doc.to_i
    whcausmag += " and causmags.id = :cm" unless causmag == "" or causmag.nil?
    hshvar[:cm] = causmag unless causmag == "" or causmag.nil?

    whconto = " and contos.tipoconto IN (:tpc)"
    hshvar[:tpc] = tpc
    whconto += " and contos.id = :cn" unless conto == "" or conto.nil?
    hshvar[:cn] = conto unless conto == "" or conto.nil?

    whana = "" 
    whana = " and anagens.#{hsh[tp]} like :d" unless des == ""
    hshvar[:d] = "%#{des}%" unless des == ""
    
    includes(:causmag, :conto =>[:anagen]).where([whcausmag + whconto + whana,
                                                  hshvar]).paginate(:page => page, :per_page => 10) unless hsh[tp].nil?
  end
end
