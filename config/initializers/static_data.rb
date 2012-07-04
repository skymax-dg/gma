# Carica il file di configurazione nella variabile array 'ParAzieda'    

$ParAzienda = YAML::load(IO.read('config/parameter.yml'))
#$ElncAznd = YAML::load(IO.read('config/aziende.yml'))

class StaticData

#  ELNCAZND = $ElncAznd['ELNCAZND']
  ELNCAZND = $ParAzienda['ELNCAZND']
#  AZIENDA = $ParAzienda['AZIENDA']
#  ANNOESE = $ParAzienda['ANNOESE']
#  ANARIF = $ParAzienda['ANARIF']
end
