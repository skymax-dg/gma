# Carica il file di configurazione nella variabile array 'ParAzieda'    

$ParAzienda = YAML::load(IO.read('config/parameter.yml'))

class StaticData

  AZIENDA = $ParAzienda['AZIENDA']
  ANNOESE = $ParAzienda['ANNOESE']

end
