namespace :gma do
  desc "a new task to be executed"
  task reset_key_words: :environment do
    KeyWord.destroy_all

    KeyWord.create(desc: 'ROOT',   parent_id: nil)

    p = KeyWord.where(desc: "ROOT")[0].id
    KeyWord.create(desc: 'Prodotti',   parent_id: p)
    KeyWord.create(desc: 'Corsi',      parent_id: p)
    KeyWord.create(desc: 'Digitale',   parent_id: p)
    KeyWord.create(desc: 'Libri',      parent_id: p)
    KeyWord.create(desc: 'Rivista',    parent_id: p)
    KeyWord.create(desc: 'Novita\'',     parent_id: p)
    KeyWord.create(desc: 'Promozioni', parent_id: p)

    p = KeyWord.where(desc: "Prodotti")[0].id
    KeyWord.create(desc: 'Sprai PHYL',          parent_id: p)
    KeyWord.create(desc: 'Integratori',         parent_id: p)
    KeyWord.create(desc: 'Tisane',              parent_id: p)
    KeyWord.create(desc: 'Profumeria',          parent_id: p)
    KeyWord.create(desc: 'Articoli Gary',       parent_id: p)
    KeyWord.create(desc: 'Jivamukti Yoga Shop', parent_id: p)
    KeyWord.create(desc: 'Poster',              parent_id: p)
    KeyWord.create(desc: 'Cuscini meditazione', parent_id: p)
    KeyWord.create(desc: 'Incensi',             parent_id: p)

    p = KeyWord.where(desc: "Corsi")[0].id
    KeyWord.create(desc: 'PHYL',                parent_id: p)
    KeyWord.create(desc: 'Scuola triennale',    parent_id: p) 
    KeyWord.create(desc: 'Trainer meditazione', parent_id: p) 
    KeyWord.create(desc: 'altri corsi',         parent_id: p) 

    p = KeyWord.where(desc: "Digitale")[0].id
    KeyWord.create(desc: 'Audiolibri',  parent_id: p)
    KeyWord.create(desc: 'Ebook',       parent_id: p) 
    KeyWord.create(desc: 'Corsi',       parent_id: p) 
    KeyWord.create(desc: 'Meditazione', parent_id: p) 
    KeyWord.create(desc: 'Rivista',     parent_id: p) 

    p = KeyWord.where(desc: "Libri")[0].id 
    KeyWord.create(desc: 'Collane', parent_id: p)
    KeyWord.create(desc: 'Generi',  parent_id: p)
    KeyWord.create(desc: 'Digital', parent_id: p)

    p = KeyWord.where(desc: "Generi")[0].id 
    KeyWord.create(desc: 'Cucina',      parent_id: p)
    KeyWord.create(desc: 'Meditazione', parent_id: p) 
    KeyWord.create(desc: 'Body Mind',   parent_id: p) 
    KeyWord.create(desc: 'Bambini',     parent_id: p) 
    KeyWord.create(desc: 'Narrativa',   parent_id: p) 
    KeyWord.create(desc: 'Angeli',      parent_id: p) 
    KeyWord.create(desc: 'Yoga',        parent_id: p) 
    KeyWord.create(desc: 'Animali',     parent_id: p) 
    KeyWord.create(desc: 'Managment',   parent_id: p) 
    KeyWord.create(desc: 'Psicologia',  parent_id: p) 
    KeyWord.create(desc: 'Religione',   parent_id: p) 

    p = KeyWord.where(desc: "Digital")[0].id
    KeyWord.create(desc: 'Audiolibri',         parent_id: p)
    KeyWord.create(desc: 'Contenuti digitali', parent_id: p)

    #RIVISTA
    p = KeyWord.where(desc: "Rivista")[0].id
    KeyWord.create(desc: 'Numeri',      parent_id: p)
    KeyWord.create(desc: 'Abbonamento', parent_id: p)
    KeyWord.create(desc: 'Digital',     parent_id: p)

    #COLLANA
    p = KeyWord.where(desc: "Collane")[0].id
    KeyWord.create(desc: 'Life',         parent_id: p)
    KeyWord.create(desc: 'Energie',      parent_id: p)
    KeyWord.create(desc: 'Eifis Junior', parent_id: p)

  end
end
