include CausmagsHelper
class Causmag < ActiveRecord::Base
  before_destroy :require_no_tesdocs
  has_many :tesdocs

  before_destroy :require_no_confs
  has_many :confs

  belongs_to :causale

  attr_accessible :azienda,  :tipo_doc, :descriz, :des_caus,  :tipo,       :movimpmag,
                  :nrmagsrc, :nrmagdst, :magcli,  :contabile, :causale_id, :modulo, :caus_tra, :grp_prg, :sfx

  validates :azienda,   :descriz,  :contabile, :tipo,
            :movimpmag, :nrmagsrc, :nrmagdst,  :magcli, :presence => true
  validates :descriz, :des_caus, :length => { :maximum => 100}

  scope :azienda, lambda { |azd| {:conditions => ['causmags.azienda = ?', azd]}}

  TIPO_DOC = $ParAzienda['CAUSMAG']['TIPO_DOC']
  TIPO = $ParAzienda['CAUSMAG']['TIPO']
  MOVIMPMAG = $ParAzienda['CAUSMAG']['MOVIMPMAG']
  MAGCLI = $ParAzienda['CAUSMAG']['MAGCLI']
  CONTABILE = $ParAzienda['CAUSMAG']['CONTABILE']
  NRMAG = $ParAzienda['ANAIND']['NRMAG']

  private
    def require_no_tesdocs
      self.errors.add :base, "Almeno un documento fa riferimento alla causale che si desidera eliminare."
      raise ActiveRecord::RecordInvalid.new self unless tesdocs.count == 0
    end
    def require_no_confs
      self.errors.add :base, "Almeno una configurazione fa riferimento alla causale che si desidera eliminare."
      raise ActiveRecord::RecordInvalid.new self unless confs.count == 0
    end
end
