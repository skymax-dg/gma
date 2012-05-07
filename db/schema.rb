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

ActiveRecord::Schema.define(:version => 20120507161422) do

  create_table "anagens", :force => true do |t|
    t.integer  "codice"
    t.string   "tipo"
    t.string   "cognome"
    t.string   "nome"
    t.string   "ragsoc"
    t.string   "codfis"
    t.string   "pariva"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.decimal  "sconto",     :precision => 5, :scale => 2, :default => 0.0
  end

  add_index "anagens", ["codfis"], :name => "idx_anagens_on_codfis", :unique => true
  add_index "anagens", ["codice"], :name => "idx_anagens_on_codice", :unique => true
  add_index "anagens", ["cognome", "nome"], :name => "idx_anagens_on_cognome-nome"
  add_index "anagens", ["pariva"], :name => "idx_anagens_on_pariva", :unique => true
  add_index "anagens", ["ragsoc"], :name => "idx_anagens_on_ragsoc"

  create_table "articles", :force => true do |t|
    t.string   "codice"
    t.string   "descriz"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.decimal  "prezzo",     :precision => 8, :scale => 2, :default => 0.0
    t.integer  "azienda",                                                   :null => false
  end

  add_index "articles", ["codice"], :name => "idx_articles_on_codice", :unique => true
  add_index "articles", ["descriz"], :name => "idx_articles_on_descriz", :unique => true

  create_table "causmags", :force => true do |t|
    t.string   "descriz"
    t.string   "tipo"
    t.integer  "magsrc_id"
    t.integer  "magdst_id"
    t.string   "contabile",  :limit => 1
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "azienda",                 :null => false
    t.string   "movimpmag",  :limit => 1
  end

  add_index "causmags", ["magdst_id"], :name => "index_causmags_on_magdst_id"
  add_index "causmags", ["magsrc_id"], :name => "index_causmags_on_magsrc_id"

  create_table "contos", :force => true do |t|
    t.integer  "azienda",                                   :null => false
    t.integer  "annoese",                                   :null => false
    t.integer  "codice",                                    :null => false
    t.string   "descriz",                                   :null => false
    t.string   "tipoconto",                                 :null => false
    t.integer  "cntrpartita"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.decimal  "sconto",      :precision => 5, :scale => 2
  end

  add_index "contos", ["azienda", "annoese", "codice"], :name => "idx_contos_on_azienda-annoese-codice", :unique => true
  add_index "contos", ["descriz"], :name => "idx_contos_on_descriz"

  create_table "mags", :force => true do |t|
    t.integer  "codice"
    t.string   "descriz"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "azienda",    :null => false
  end

  create_table "prezzoarticclis", :force => true do |t|
    t.integer  "anag_id"
    t.integer  "artic_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.decimal  "prezzo",     :precision => 8, :scale => 2
  end

  add_index "prezzoarticclis", ["anag_id"], :name => "index_prezzoarticclis_on_anag_id"
  add_index "prezzoarticclis", ["artic_id"], :name => "index_prezzoarticclis_on_artic_id"

  create_table "tesdocs", :force => true do |t|
    t.string   "tipo_doc",   :limit => 1
    t.integer  "num_doc"
    t.date     "data_doc"
    t.string   "descriz",    :limit => 150
    t.integer  "causmag_id"
    t.integer  "anagen_id"
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
    t.decimal  "sconto",                    :precision => 5, :scale => 2, :default => 0.0
    t.integer  "azienda",                                                                  :null => false
    t.integer  "annoese",                                                                  :null => false
  end

  add_index "tesdocs", ["anagen_id"], :name => "index_tesdocs_on_anagen_id"
  add_index "tesdocs", ["causmag_id"], :name => "index_tesdocs_on_causmag_id"

end
