class Conf < ActiveRecord::Base
  attr_accessible :codice,      :descriz,    :insana,   :insind, :insart,    :coderigdoc, :defcaustra,
                  :defcorriere, :defaspetto, :defporto, :defum,  :defvalore, :defnrcolli, :defdtrit,
                  :deforarit,   :defnote,    :defpagam, :defbanca

  validates :descriz,  :length => { :maximum => 100}
  validates :defnote,  :length => { :maximum => 1000}
  validates :defpagam, :length => { :maximum => 500}
  validates :defbanca, :length => { :maximum => 200}

  INSANA     = $ParAzienda['CONF']['INSANA']
  INSIND     = $ParAzienda['CONF']['INSIND']
  INSART     = $ParAzienda['CONF']['INSART']
  CODERIGDOC = $ParAzienda['CONF']['CODERIGDOC']
  CAUSTRA    = $ParAzienda['SPEDIZ']['CAUSTRA']
  CORRIERE   = $ParAzienda['SPEDIZ']['CORRIERE']
  ASPETTO    = $ParAzienda['SPEDIZ']['ASPETTO']
  PORTO      = $ParAzienda['SPEDIZ']['PORTO']
  UM         = $ParAzienda['SPEDIZ']['UM']

end
