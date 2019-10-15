# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20191015125151) do

  create_table "agentes", :force => true do |t|
    t.integer  "anagen_id"
    t.decimal  "provv",      :precision => 5, :scale => 2, :null => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "anagen_articles", :force => true do |t|
    t.integer  "anagen_id"
    t.integer  "article_id"
    t.integer  "mode",       :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "anagen_articles", ["mode"], :name => "index_anagen_articles_on_mode"

  create_table "anagens", :force => true do |t|
    t.integer  "codice",                                           :null => false
    t.string   "tipo",               :limit => 1,                  :null => false
    t.string   "codfis",             :limit => 16
    t.string   "pariva",             :limit => 11
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "denomin",            :limit => 150,                :null => false
    t.string   "telefono",           :limit => 20
    t.string   "email",              :limit => 50
    t.string   "fax",                :limit => 20
    t.string   "web",                :limit => 50
    t.date     "dtnas"
    t.string   "sesso",              :limit => 1
    t.integer  "luogonas_id"
    t.string   "referente",          :limit => 150
    t.string   "type"
    t.string   "codnaz",             :limit => 2
    t.string   "codident",           :limit => 20
    t.string   "pec",                :limit => 50
    t.text     "bio"
    t.string   "cod_cig",            :limit => 20
    t.string   "cod_cup",            :limit => 20
    t.integer  "split_payement",                    :default => 0
    t.string   "cod_carta_studente", :limit => 7
    t.string   "cod_carta_docente",  :limit => 8
    t.integer  "attivo",                            :default => 1
    t.integer  "primary_address_id"
    t.integer  "paese_nas_id"
  end

  add_index "anagens", ["codfis"], :name => "idx_anagens_on_codfis"
  add_index "anagens", ["codice"], :name => "idx_anagens_on_codice", :unique => true
  add_index "anagens", ["denomin"], :name => "idx_anagens_on_denomin"
  add_index "anagens", ["pariva"], :name => "idx_anagens_on_pariva"

  create_table "anainds", :force => true do |t|
    t.integer  "anagen_id"
    t.string   "indir"
    t.string   "desloc"
    t.string   "cap",         :limit => 10
    t.integer  "nrmag",                                      :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "localita_id"
    t.string   "flsl",        :limit => 1,  :default => "S", :null => false
    t.string   "flsp",        :limit => 1,  :default => "S", :null => false
    t.string   "flmg",        :limit => 1,  :default => "N", :null => false
  end

  add_index "anainds", ["anagen_id"], :name => "index_anainds_on_anagen_id"

  create_table "articles", :force => true do |t|
    t.integer  "azienda",                                                                     :null => false
    t.string   "codice",      :limit => 20,                                                   :null => false
    t.string   "descriz",     :limit => 100,                                                  :null => false
    t.decimal  "prezzo",                     :precision => 12, :scale => 6, :default => 0.0,  :null => false
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
    t.string   "categ",       :limit => 2,                                  :default => "GE", :null => false
    t.integer  "iva_id",                                                    :default => 1,    :null => false
    t.decimal  "costo",                      :precision => 8,  :scale => 2, :default => 0.0,  :null => false
    t.text     "subtitle"
    t.text     "sinossi"
    t.text     "abstract"
    t.text     "quote"
    t.integer  "weigth"
    t.integer  "ppc",                                                       :default => 1
    t.integer  "ppb"
    t.integer  "state"
    t.integer  "width"
    t.integer  "height"
    t.date     "dtpub"
    t.decimal  "discount",                   :precision => 5,  :scale => 2, :default => 0.0,  :null => false
    t.integer  "pagine"
    t.integer  "rilegatura"
    t.text     "issuee_link"
  end

  add_index "articles", ["azienda", "codice"], :name => "idx_articles_on_codice", :unique => true
  add_index "articles", ["azienda", "descriz"], :name => "idx_articles_on_descriz", :unique => true

  create_table "causales", :force => true do |t|
    t.integer  "azienda",                   :null => false
    t.string   "descriz",    :limit => 100, :null => false
    t.string   "tipoiva",    :limit => 1,   :null => false
    t.string   "tiporeg",    :limit => 1,   :null => false
    t.integer  "contoiva"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "causmags", :force => true do |t|
    t.integer  "azienda",                                    :null => false
    t.string   "descriz",    :limit => 100,                  :null => false
    t.string   "tipo",       :limit => 1,                    :null => false
    t.string   "movimpmag",  :limit => 1,                    :null => false
    t.string   "contabile",  :limit => 1,                    :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "tipo_doc",                  :default => 0,   :null => false
    t.string   "des_caus",   :limit => 100
    t.string   "modulo",     :limit => 50
    t.integer  "nrmagsrc",                                   :null => false
    t.integer  "nrmagdst",                                   :null => false
    t.integer  "causale_id"
    t.string   "magcli",     :limit => 1,   :default => "N"
    t.string   "caus_tra",   :limit => 50
    t.integer  "grp_prg"
    t.string   "sfx",        :limit => 5
  end

  add_index "causmags", ["azienda", "descriz"], :name => "idx_causmags_on_descriz", :unique => true
  add_index "causmags", ["grp_prg"], :name => "index_causmags_on_grp_prg"

  create_table "confs", :force => true do |t|
    t.string   "codice",      :limit => 20,                                 :null => false
    t.string   "descriz",     :limit => 100
    t.string   "insana",      :limit => 1,                                  :null => false
    t.string   "insind",      :limit => 1,                                  :null => false
    t.string   "insart",      :limit => 1,                                  :null => false
    t.string   "coderigdoc",  :limit => 1,                                  :null => false
    t.string   "defcaustra",  :limit => 3
    t.string   "defcorriere", :limit => 3
    t.string   "defaspetto",  :limit => 3
    t.integer  "defnrcolli"
    t.string   "defum",       :limit => 2
    t.decimal  "defvalore",                   :precision => 8, :scale => 2
    t.string   "defporto",    :limit => 3
    t.date     "defdtrit"
    t.time     "deforarit"
    t.string   "defnote",     :limit => 1000
    t.string   "defpagam",    :limit => 500
    t.string   "defbanca",    :limit => 200
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.integer  "defcausmag"
    t.date     "defdatadoc"
    t.string   "defdesdoc",   :limit => 150
  end

  create_table "contos", :force => true do |t|
    t.integer  "azienda",                                                                   :null => false
    t.integer  "annoese",                                                                   :null => false
    t.integer  "codice",                                                                    :null => false
    t.string   "descriz",     :limit => 150,                                                :null => false
    t.string   "tipoconto",   :limit => 1,                                                  :null => false
    t.integer  "cntrpartita"
    t.decimal  "sconto",                     :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
    t.integer  "anagen_id"
    t.string   "tipopeo",     :limit => 1,                                                  :null => false
  end

  add_index "contos", ["azienda", "annoese", "codice"], :name => "idx_contos_on_codice", :unique => true
  add_index "contos", ["azienda", "annoese", "descriz"], :name => "idx_contos_on_descriz"

  create_table "costos", :force => true do |t|
    t.integer  "tesdoc_id",                                                                :null => false
    t.date     "data"
    t.string   "tipo_spe",   :limit => 2,                                                  :null => false
    t.string   "stato",      :limit => 2,                                                  :null => false
    t.string   "descriz",    :limit => 100
    t.decimal  "importo",                   :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
  end

  add_index "costos", ["data"], :name => "index_costos_on_data"
  add_index "costos", ["tesdoc_id"], :name => "index_costos_on_tesdoc_id"

  create_table "event_states", :force => true do |t|
    t.integer  "event_id"
    t.integer  "anagen_id"
    t.integer  "mode"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "type",           :limit => 24
    t.string   "description",    :limit => 40
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "article_id"
    t.string   "timetable",      :limit => 20
    t.text     "dressing"
    t.integer  "duration"
    t.integer  "quantity"
    t.integer  "nr_item"
    t.integer  "yr_item"
    t.integer  "site_anagen_id"
    t.integer  "state"
    t.integer  "mode"
    t.integer  "cut_off"
    t.date     "dt_event"
    t.date     "dt_end_isc"
    t.date     "dt_discount"
  end

  create_table "ivas", :force => true do |t|
    t.integer  "codice",                                                  :null => false
    t.string   "descriz",    :limit => 50,                                :null => false
    t.string   "desest",     :limit => 150,                               :null => false
    t.decimal  "aliq",                      :precision => 5, :scale => 2, :null => false
    t.string   "flese",      :limit => 1,                                 :null => false
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
  end

  create_table "key_word_rels", :force => true do |t|
    t.integer  "key_word_id"
    t.string   "desc",              :limit => 32
    t.integer  "key_wordable_id"
    t.string   "key_wordable_type"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "key_words", :force => true do |t|
    t.string   "desc",         :limit => 32
    t.integer  "parent_id"
    t.integer  "keyword_type",               :default => 0
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "type",         :limit => 24
    t.integer  "n_order",                    :default => 0
  end

  create_table "localitas", :force => true do |t|
    t.string   "descriz",     :limit => 50, :null => false
    t.string   "prov",        :limit => 2
    t.string   "cap",         :limit => 10
    t.integer  "paese_id"
    t.string   "codfis",      :limit => 4
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "cod_regione"
    t.string   "state",       :limit => 30
  end

  add_index "localitas", ["descriz"], :name => "idx_localitas_on_descriz"
  add_index "localitas", ["paese_id"], :name => "index_localitas_on_paese_id"

  create_table "paeses", :force => true do |t|
    t.string   "descriz",    :limit => 50, :null => false
    t.string   "tpeu",       :limit => 1,  :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "prepiva",    :limit => 2
    t.string   "codfis",     :limit => 4
  end

  add_index "paeses", ["descriz"], :name => "idx_paeses_on_descriz", :unique => true

  create_table "prezzoarticclis", :force => true do |t|
    t.integer  "azienda",                                  :null => false
    t.integer  "anag_id"
    t.integer  "artic_id"
    t.decimal  "prezzo",     :precision => 8, :scale => 2, :null => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "prezzoarticclis", ["azienda", "anag_id", "artic_id"], :name => "index_prezzoarticclis_on_azienda_and_anag_id_and_artic_id", :unique => true
  add_index "prezzoarticclis", ["azienda", "anag_id"], :name => "index_prezzoarticclis_on_azienda_and_anag_id"
  add_index "prezzoarticclis", ["azienda", "artic_id"], :name => "index_prezzoarticclis_on_azienda_and_artic_id"

  create_table "rigdocs", :force => true do |t|
    t.integer  "tesdoc_id",                                                                 :null => false
    t.integer  "article_id"
    t.string   "descriz",    :limit => 150
    t.integer  "qta"
    t.decimal  "prezzo",                    :precision => 12, :scale => 6, :default => 0.0, :null => false
    t.decimal  "sconto",                    :precision => 5,  :scale => 2, :default => 0.0, :null => false
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
    t.integer  "prgrig",                                                   :default => 0,   :null => false
    t.integer  "iva_id"
  end

  add_index "rigdocs", ["article_id"], :name => "index_rigdocs_on_article_id"
  add_index "rigdocs", ["descriz"], :name => "index_rigdocs_on_descriz"
  add_index "rigdocs", ["tesdoc_id", "prgrig"], :name => "index_rigdocs_on_tesdoc_id_and_prgrig", :unique => true
  add_index "rigdocs", ["tesdoc_id"], :name => "index_rigdocs_on_tesdoc_id"

  create_table "scadenzas", :force => true do |t|
    t.integer  "tesdoc_id",                                                                 :null => false
    t.date     "data"
    t.string   "tipo",       :limit => 2,                                                   :null => false
    t.string   "stato",      :limit => 1,                                                   :null => false
    t.string   "descriz",    :limit => 100
    t.decimal  "importo",                   :precision => 12, :scale => 6, :default => 0.0, :null => false
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
  end

  add_index "scadenzas", ["data"], :name => "index_scadenzas_on_data"
  add_index "scadenzas", ["tesdoc_id"], :name => "index_scadenzas_on_tesdoc_id"

  create_table "spedizs", :force => true do |t|
    t.integer  "tesdoc_id",                                                :null => false
    t.string   "caustra",    :limit => 3
    t.string   "corriere",   :limit => 3
    t.string   "dest1",      :limit => 150
    t.string   "dest2",      :limit => 150
    t.string   "aspetto",    :limit => 3
    t.integer  "nrcolli"
    t.string   "um",         :limit => 2
    t.decimal  "valore",                     :precision => 8, :scale => 2
    t.string   "porto",      :limit => 3
    t.date     "dtrit"
    t.time     "orarit"
    t.string   "note",       :limit => 1000
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.integer  "anaind_id"
    t.string   "presso",     :limit => 150
    t.string   "pagam",      :limit => 500
    t.string   "banca",      :limit => 200
  end

  add_index "spedizs", ["tesdoc_id"], :name => "index_spedizs_on_tesdoc_id"

  create_table "tesdocs", :force => true do |t|
    t.integer  "azienda",                                                                  :null => false
    t.integer  "annoese",                                                                  :null => false
    t.integer  "num_doc",                                                                  :null => false
    t.date     "data_doc",                                                                 :null => false
    t.string   "descriz",    :limit => 150
    t.integer  "causmag_id"
    t.integer  "conto_id"
    t.decimal  "sconto",                    :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
    t.integer  "nrmagsrc",                                                :default => 0,   :null => false
    t.integer  "nrmagdst",                                                :default => 0,   :null => false
    t.string   "seguefatt",  :limit => 1,                                 :default => "N", :null => false
    t.integer  "tipo_doc",                                                :default => 0,   :null => false
    t.integer  "iva_id"
    t.integer  "agente_id"
    t.string   "oggetto",    :limit => 150
  end

  add_index "tesdocs", ["causmag_id"], :name => "index_tesdocs_on_causmag_id"
  add_index "tesdocs", ["conto_id"], :name => "index_tesdocs_on_conto_id"
  add_index "tesdocs", ["data_doc", "num_doc"], :name => "idx_tesdocs_on_data_doc_num_doc"

  create_table "users", :force => true do |t|
    t.integer  "azienda",                                    :null => false
    t.string   "login",        :limit => 20,                 :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "salt",         :limit => 100,                :null => false
    t.string   "pwdcript",     :limit => 100,                :null => false
    t.integer  "anagen_id"
    t.integer  "user_tp",                     :default => 1
    t.integer  "privilege",                   :default => 1
    t.string   "token"
    t.datetime "dt_exp_token"
    t.string   "email",        :limit => 60
  end

  add_index "users", ["azienda", "login"], :name => "idx_users_on_login", :unique => true

end
