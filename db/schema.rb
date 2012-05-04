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

ActiveRecord::Schema.define(:version => 20120504161156) do

  create_table "anagens", :force => true do |t|
    t.integer  "codice"
    t.string   "tipo"
    t.string   "cognome"
    t.string   "nome"
    t.string   "ragsoc"
    t.string   "codfis"
    t.string   "pariva"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "anagens", ["codfis"], :name => "idx_anagens_on_codfis", :unique => true
  add_index "anagens", ["codice"], :name => "idx_anagens_on_codice", :unique => true
  add_index "anagens", ["pariva"], :name => "idx_anagens_on_pariva", :unique => true

  create_table "articles", :force => true do |t|
    t.string   "codice"
    t.string   "descriz"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "articles", ["codice"], :name => "idx_articles_on_codice", :unique => true
  add_index "articles", ["descriz"], :name => "idx_articles_on_descriz", :unique => true

  create_table "causmags", :force => true do |t|
    t.string   "descriz"
    t.string   "tipo"
    t.integer  "magsrc_id"
    t.integer  "magdst_id"
    t.string   "fattura"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "causmags", ["magdst_id"], :name => "index_causmags_on_magdst_id"
  add_index "causmags", ["magsrc_id"], :name => "index_causmags_on_magsrc_id"

  create_table "mags", :force => true do |t|
    t.integer  "codice"
    t.string   "descriz"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
