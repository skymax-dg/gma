namespace :gma do
  desc "a new task to be executed"
  task reset_key_words: :environment do
    KeyWord.destroy_all

    root = 'Root articoli'
    KeyWordArticle.create(desc: root,   parent_id: nil)

    p = KeyWordArticle.where(desc: root)[0].id
    KeyWordArticle.create(desc: 'Prodotti',   parent_id: p)
    KeyWordArticle.create(desc: 'Digitale',   parent_id: p)
    KeyWordArticle.create(desc: 'Libri',      parent_id: p)
    KeyWordArticle.create(desc: 'Rivista',    parent_id: p)
    KeyWordArticle.create(desc: 'Novita\'',   parent_id: p)
    KeyWordArticle.create(desc: 'Promozioni', parent_id: p)

    p = KeyWordArticle.where(desc: "Prodotti")[0].id
    KeyWordArticle.create(desc: 'Sprai PHYL',          parent_id: p)
    KeyWordArticle.create(desc: 'Integratori',         parent_id: p)
    KeyWordArticle.create(desc: 'Tisane',              parent_id: p)
    KeyWordArticle.create(desc: 'Profumeria',          parent_id: p)
    KeyWordArticle.create(desc: 'Articoli Gary',       parent_id: p)
    KeyWordArticle.create(desc: 'Jivamukti Yoga Shop', parent_id: p)
    KeyWordArticle.create(desc: 'Poster',              parent_id: p)
    KeyWordArticle.create(desc: 'Cuscini meditazione', parent_id: p)
    KeyWordArticle.create(desc: 'Incensi',             parent_id: p)

    p = KeyWordArticle.where(desc: "Digitale")[0].id
    KeyWordArticle.create(desc: 'Audiolibri',  parent_id: p)
    KeyWordArticle.create(desc: 'Ebook',       parent_id: p) 
    KeyWordArticle.create(desc: 'Corsi',       parent_id: p) 
    KeyWordArticle.create(desc: 'Meditazione', parent_id: p) 
    KeyWordArticle.create(desc: 'Rivista',     parent_id: p) 

    p = KeyWordArticle.where(desc: "Libri")[0].id 
    KeyWordArticle.create(desc: 'Collane', parent_id: p)
    KeyWordArticle.create(desc: 'Generi',  parent_id: p)
    KeyWordArticle.create(desc: 'Digital', parent_id: p)

    p = KeyWordArticle.where(desc: "Generi")[0].id 
    KeyWordArticle.create(desc: 'Cucina',      parent_id: p)
    KeyWordArticle.create(desc: 'Meditazione', parent_id: p) 
    KeyWordArticle.create(desc: 'Body Mind',   parent_id: p) 
    KeyWordArticle.create(desc: 'Bambini',     parent_id: p) 
    KeyWordArticle.create(desc: 'Narrativa',   parent_id: p) 
    KeyWordArticle.create(desc: 'Angeli',      parent_id: p) 
    KeyWordArticle.create(desc: 'Yoga',        parent_id: p) 
    KeyWordArticle.create(desc: 'Animali',     parent_id: p) 
    KeyWordArticle.create(desc: 'Managment',   parent_id: p) 
    KeyWordArticle.create(desc: 'Psicologia',  parent_id: p) 
    KeyWordArticle.create(desc: 'Religione',   parent_id: p) 

    p = KeyWordArticle.where(desc: "Digital")[0].id
    KeyWordArticle.create(desc: 'Audiolibri',         parent_id: p)
    KeyWordArticle.create(desc: 'Contenuti digitali', parent_id: p)

    #RIVISTA
    p = KeyWordArticle.where(desc: "Rivista")[0].id
    KeyWordArticle.create(desc: 'Numeri',      parent_id: p)
    KeyWordArticle.create(desc: 'Abbonamento', parent_id: p)
    KeyWordArticle.create(desc: 'Digital',     parent_id: p)

    #COLLANA
    p = KeyWordArticle.where(desc: "Collane")[0].id
    KeyWordArticle.create(desc: 'Life',         parent_id: p)
    KeyWordArticle.create(desc: 'Energie',      parent_id: p)
    KeyWordArticle.create(desc: 'Eifis Junior', parent_id: p)

    puts "OK KeyWord Article"

    ##########################################

    root = 'Root anagrafica'
    KeyWordAnagen.create(desc: root,   parent_id: nil)

    p = KeyWordAnagen.where(desc: root)[0].id
    KeyWordAnagen.create(desc: 'Autore',     parent_id: p)
    KeyWordAnagen.create(desc: 'Stampatore', parent_id: p)

    puts "OK KeyWord Anagen"

    #######################################
    root = 'Root eventi'
    KeyWordEvent.create(desc: root,   parent_id: nil)

    p = KeyWordEvent.where(desc: root)[0].id
    KeyWordEvent.create(desc: 'Corsi',      parent_id: p)
    KeyWordEvent.create(desc: 'Novita\'',   parent_id: p)
    KeyWordEvent.create(desc: 'Promozioni', parent_id: p)

    p = KeyWordEvent.where(desc: "Corsi")[0].id
    KeyWordEvent.create(desc: 'PHYL',                parent_id: p)
    KeyWordEvent.create(desc: 'Scuola triennale',    parent_id: p) 
    KeyWordEvent.create(desc: 'Trainer meditazione', parent_id: p) 
    KeyWordEvent.create(desc: 'altri corsi',         parent_id: p) 

    puts "OK KeyWord Event"

  end
end
