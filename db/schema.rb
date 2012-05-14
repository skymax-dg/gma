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

ActiveRecord::Schema.define(:version => 20120514144637) do

  create_table "anagens", :force => true do |t|
    t.integer  "codice",                                                                   :null => false
    t.string   "tipo",       :limit => 1,                                                  :null => false
    t.string   "codfis",     :limit => 16
    t.string   "pariva",     :limit => 11
    t.decimal  "sconto",                    :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
    t.string   "denomin",    :limit => 150
    t.string   "telefono",   :limit => 20
    t.string   "email",      :limit => 50
    t.string   "fax",        :limit => 20
    t.string   "web",        :limit => 50
  end

  add_index "anagens", ["codfis"], :name => "idx_anagens_on_codfis", :unique => true
  add_index "anagens", ["codice"], :name => "idx_anagens_on_codice", :unique => true
  add_index "anagens", ["denomin"], :name => "idx_anagens_on_denomin"
  add_index "anagens", ["pariva"], :name => "idx_anagens_on_pariva", :unique => true

  create_table "articles", :force => true do |t|
    t.integer  "azienda",                                                                  :null => false
    t.string   "codice",     :limit => 20,                                                 :null => false
    t.string   "descriz",    :limit => 100,                                                :null => false
    t.decimal  "prezzo",                    :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
  end

  add_index "articles", ["azienda", "codice"], :name => "idx_articles_on_codice", :unique => true
  add_index "articles", ["azienda", "descriz"], :name => "idx_articles_on_descriz", :unique => true

  create_table "causmags", :force => true do |t|
    t.integer  "azienda",                                  :null => false
    t.string   "descriz",    :limit => 100,                :null => false
    t.string   "tipo",       :limit => 1,                  :null => false
    t.string   "movimpmag",  :limit => 1,                  :null => false
    t.string   "contabile",  :limit => 1,                  :null => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "tipo_doc",                  :default => 0, :null => false
    t.string   "des_caus",   :limit => 100
    t.string   "modulo",     :limit => 50
    t.integer  "nrmag_src"
    t.integer  "nrmag_dst"
  end

  add_index "causmags", ["azienda", "descriz"], :name => "idx_causmags_on_descriz", :unique => true

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
  end

  add_index "contos", ["azienda", "annoese", "codice"], :name => "idx_contos_on_codice", :unique => true
  add_index "contos", ["azienda", "annoese", "descriz"], :name => "idx_contos_on_descriz"

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
    t.integer  "tesdoc_id",                                                                :null => false
    t.integer  "article_id"
    t.string   "descriz",    :limit => 150
    t.integer  "qta"
    t.decimal  "prezzo",                    :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "sconto",                    :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
    t.integer  "prgrig",                                                  :default => 0,   :null => false
  end

  add_index "rigdocs", ["article_id"], :name => "index_rigdocs_on_article_id"
  add_index "rigdocs", ["descriz"], :name => "index_rigdocs_on_descriz"
  add_index "rigdocs", ["tesdoc_id", "prgrig"], :name => "index_rigdocs_on_tesdoc_id_and_prgrig", :unique => true
  add_index "rigdocs", ["tesdoc_id"], :name => "index_rigdocs_on_tesdoc_id"

  create_table "tesdocs", :force => true do |t|
    t.integer  "azienda",                                                                  :null => false
    t.integer  "annoese",                                                                  :null => false
    t.string   "tipo_doc",   :limit => 1,                                                  :null => false
    t.integer  "num_doc",                                                                  :null => false
    t.date     "data_doc",                                                                 :null => false
    t.string   "descriz",    :limit => 150
    t.integer  "causmag_id"
    t.integer  "conto_id"
    t.decimal  "sconto",                    :precision => 5, :scale => 2, :default => 0.0, :null => false
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
  end

  add_index "tesdocs", ["causmag_id"], :name => "index_tesdocs_on_causmag_id"
  add_index "tesdocs", ["conto_id"], :name => "index_tesdocs_on_conto_id"

  create_table "users", :force => true do |t|
    t.integer  "azienda",                  :null => false
    t.string   "login",      :limit => 20, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "users", ["azienda", "login"], :name => "idx_users_on_login", :unique => true

end
