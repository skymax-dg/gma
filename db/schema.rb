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

ActiveRecord::Schema.define(:version => 20200219123132) do

  create_table "actions_counters", :force => true do |t|
    t.integer  "counter"
    t.integer  "max_count"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "controller", :limit => nil
    t.string   "action",     :limit => nil
    t.integer  "user_id"
  end

  create_table "agentes", :force => true do |t|
    t.integer  "anagen_id"
    t.decimal  "provv",      :precision => 5, :scale => 2, :null => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "anag_socials", :force => true do |t|
    t.integer  "anagen_id"
    t.string   "stype",      :limit => 4
    t.string   "saddr",      :limit => 50
    t.integer  "state",                    :default => 1
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
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
    t.integer  "codice",                                             :null => false
    t.string   "tipo",                 :limit => 1,                  :null => false
    t.string   "codfis",               :limit => 16
    t.string   "pariva",               :limit => 11
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "denomin",              :limit => 150,                :null => false
    t.string   "telefono",             :limit => 20
    t.string   "email",                :limit => 50
    t.string   "fax",                  :limit => 20
    t.string   "web",                  :limit => 50
    t.date     "dtnas"
    t.string   "sesso",                :limit => 1
    t.integer  "luogonas_id"
    t.string   "referente",            :limit => 150
    t.string   "type"
    t.string   "codnaz",               :limit => 2
    t.string   "codident",             :limit => 20
    t.string   "pec",                  :limit => 50
    t.text     "bio"
    t.string   "cod_cig",              :limit => 20
    t.string   "cod_cup",              :limit => 20
    t.integer  "split_payement",                      :default => 0
    t.string   "cod_carta_studente",   :limit => 7
    t.string   "cod_carta_docente",    :limit => 8
    t.integer  "attivo",                              :default => 1
    t.integer  "primary_address_id"
    t.integer  "paese_nas_id"
    t.integer  "fl1_consenso",                        :default => 0
    t.integer  "fl2_consenso",                        :default => 0
    t.date     "dt_consenso"
    t.integer  "fl_newsletter",                       :default => 0
    t.string   "cellulare",            :limit => 15
    t.string   "youtube_presentation", :limit => 50
    t.date     "dt_revoca_consenso"
    t.integer  "fl3_consenso",                        :default => 0
    t.integer  "fl4_consenso",                        :default => 0
    t.integer  "fl5_consenso",                        :default => 0
    t.integer  "fl6_consenso",                        :default => 0
    t.integer  "stato_consenso",                      :default => 0
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

  create_table "app_params", :force => true do |t|
    t.integer  "user_id"
    t.string   "name",        :limit => nil
    t.string   "code",        :limit => nil
    t.string   "description", :limit => nil
    t.string   "cparam",      :limit => nil
    t.string   "value",       :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_params", ["code"], :name => "index_app_params_on_code"
  add_index "app_params", ["user_id"], :name => "index_app_params_on_user_id"

  create_table "articles", :force => true do |t|
    t.integer  "azienda",                                                                              :null => false
    t.string   "codice",               :limit => 20,                                                   :null => false
    t.string   "descriz",              :limit => 100,                                                  :null => false
    t.decimal  "prezzo",                              :precision => 12, :scale => 6, :default => 0.0,  :null => false
    t.datetime "created_at",                                                                           :null => false
    t.datetime "updated_at",                                                                           :null => false
    t.string   "categ",                :limit => 2,                                  :default => "GE", :null => false
    t.integer  "iva_id",                                                             :default => 1,    :null => false
    t.decimal  "costo",                               :precision => 8,  :scale => 2, :default => 0.0,  :null => false
    t.text     "subtitle"
    t.text     "sinossi"
    t.text     "abstract"
    t.text     "quote"
    t.integer  "weigth"
    t.integer  "ppc",                                                                :default => 1
    t.integer  "ppb"
    t.integer  "state"
    t.integer  "width"
    t.integer  "height"
    t.date     "dtpub"
    t.decimal  "discount",                            :precision => 5,  :scale => 2, :default => 0.0,  :null => false
    t.integer  "pagine"
    t.integer  "rilegatura"
    t.text     "issuee_link"
    t.string   "translator",           :limit => 30
    t.string   "series",               :limit => 30
    t.string   "director_series",      :limit => 30
    t.string   "collaborator",         :limit => 30
    t.string   "youtube_presentation", :limit => 50
  end

  add_index "articles", ["azienda", "codice"], :name => "idx_articles_on_codice", :unique => true
  add_index "articles", ["azienda", "descriz"], :name => "idx_articles_on_descriz", :unique => true

  create_table "basic_units", :force => true do |t|
    t.string  "desc_it",     :limit => 32
    t.string  "desc_en",     :limit => 32
    t.string  "desc_es",     :limit => 32
    t.string  "desc_imp_it", :limit => 32
    t.string  "desc_imp_en", :limit => 32
    t.string  "desc_imp_es", :limit => 32
    t.decimal "fatt_conv",                 :precision => 10, :scale => 6
    t.integer "precision"
    t.string  "datatype",    :limit => 32
    t.string  "desc_ja",     :limit => 80
    t.string  "desc_de",     :limit => 80
    t.string  "desc_br",     :limit => 80
    t.string  "desc_fr",     :limit => 80
    t.string  "desc_imp_ja", :limit => 80
    t.string  "desc_imp_de", :limit => 80
    t.string  "desc_imp_br", :limit => 80
    t.string  "desc_imp_fr", :limit => 80
  end

  create_table "blog_comments", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.integer  "parent_category_id"
    t.integer  "origin_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["origin_category_id"], :name => "index_categories_on_origin_category_id"
  add_index "categories", ["parent_category_id"], :name => "index_categories_on_parent_category_id"

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

  create_table "coap_allergens", :force => true do |t|
    t.integer  "gac_license_id"
    t.string   "parola",         :limit => 80
    t.string   "allergene",      :limit => 80
    t.integer  "falso_positivo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coap_orders", :force => true do |t|
    t.integer  "gac_license_id"
    t.string   "ord_num",        :limit => 12
    t.datetime "dt_mov"
    t.string   "cod_prod",       :limit => 20
    t.string   "cod_lotto",      :limit => 15
    t.integer  "product_id"
    t.string   "desc_prod",      :limit => 80
    t.string   "cod_cli",        :limit => 12
    t.string   "rag_soc",        :limit => 50
    t.datetime "dt_scad"
    t.decimal  "qta",                          :precision => 9, :scale => 3
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_mov"
    t.date     "date_scad"
    t.integer  "file_num"
  end

  add_index "coap_orders", ["cod_cli"], :name => "index_coap_orders_on_cod_cli"
  add_index "coap_orders", ["cod_lotto"], :name => "index_coap_orders_on_cod_lotto"
  add_index "coap_orders", ["cod_prod"], :name => "index_coap_orders_on_cod_prod"
  add_index "coap_orders", ["dt_mov"], :name => "index_coap_orders_on_dt_mov"
  add_index "coap_orders", ["gac_license_id"], :name => "index_coap_orders_on_gac_license_id"
  add_index "coap_orders", ["ord_num"], :name => "index_coap_orders_on_ord_num"
  add_index "coap_orders", ["product_id"], :name => "index_coap_orders_on_product_id"

  create_table "coap_prod_comps", :force => true do |t|
    t.integer  "product_id"
    t.string   "code",             :limit => 20
    t.string   "description",      :limit => 650
    t.string   "allergene",        :limit => 1
    t.string   "unmis",            :limit => 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "coap_allergen_id"
    t.integer  "allergen_id"
    t.integer  "super_comp_id"
  end

  add_index "coap_prod_comps", ["super_comp_id"], :name => "index_coap_prod_comps_on_super_comp_id"

  create_table "coap_products", :force => true do |t|
    t.integer  "gac_license_id"
    t.string   "code",           :limit => 20
    t.string   "description",    :limit => 80
    t.string   "tipo",           :limit => 1
    t.string   "dism",           :limit => 1
    t.string   "unmis",          :limit => 4
    t.string   "codfam",         :limit => 4
    t.decimal  "ord_min",                      :precision => 6, :scale => 2
    t.integer  "cod_comp_base"
    t.string   "desc_comp_base", :limit => 60
    t.decimal  "kcalg",                        :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "kjg",                          :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "prot",                         :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "carb",                         :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "carb2",                        :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "fat",                          :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "fats",                         :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "fiber",                        :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "fibers",                       :precision => 8, :scale => 2, :default => 0.0
    t.decimal  "salt",                         :precision => 8, :scale => 2, :default => 0.0
    t.integer  "allergen_id"
    t.integer  "gac_view_id"
  end

  create_table "coap_recipe_items", :force => true do |t|
    t.integer  "recipe_id"
    t.integer  "row"
    t.decimal  "qta_perc",   :precision => 6, :scale => 2
    t.decimal  "peso",       :precision => 8, :scale => 2
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coap_recipes", :force => true do |t|
    t.integer  "gac_license_id"
    t.string   "code",           :limit => 20
    t.string   "description",    :limit => 80
    t.text     "notes"
    t.string   "procedim",       :limit => 1650
    t.string   "author",         :limit => 16
    t.string   "group",          :limit => 20
    t.decimal  "calo_peso_perc",                 :precision => 6, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "public_flag",                                                  :default => 0
  end

  create_table "companies", :force => true do |t|
    t.string   "name",                 :limit => nil
    t.string   "address",              :limit => nil
    t.string   "city",                 :limit => nil
    t.string   "province",             :limit => nil
    t.string   "vat",                  :limit => nil
    t.string   "cod_fisc",             :limit => nil
    t.string   "cap",                  :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code",                 :limit => nil
    t.string   "picture_file_name",    :limit => nil
    t.string   "picture_content_type", :limit => nil
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "url",                  :limit => nil
  end

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

  create_table "cons_modules", :force => true do |t|
    t.integer  "mod_type",   :default => 0
    t.integer  "state",      :default => 0
    t.date     "dt_optin"
    t.date     "dt_optout"
    t.text     "desc"
    t.integer  "flag1",      :default => 0
    t.integer  "flag2",      :default => 0
    t.integer  "flag3",      :default => 0
    t.integer  "flag4",      :default => 0
    t.integer  "flag5",      :default => 0
    t.integer  "flag6",      :default => 0
    t.integer  "anagen_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
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

  create_table "coupons", :force => true do |t|
    t.integer  "anagen_id"
    t.integer  "state",                                :default => 0
    t.decimal  "value",                                :default => 0.0
    t.decimal  "perc",                                 :default => 0.0
    t.date     "dt_start"
    t.date     "dt_end"
    t.date     "dt_use"
    t.decimal  "ord_min",                              :default => 0.0
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "code",                   :limit => 30
    t.string   "batch_code",             :limit => 20
    t.integer  "togli_spese_spedizione",               :default => 1
  end

  create_table "currencies", :force => true do |t|
    t.string   "description", :limit => 50
    t.string   "sigla",       :limit => 3
    t.decimal  "fat_cnv",                   :precision => 12, :scale => 6, :null => false
    t.date     "dt_val"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "currencies", ["sigla", "dt_val"], :name => "index_currencies_on_sigla_and_dt_val", :unique => true
  add_index "currencies", ["sigla"], :name => "index_currencies_on_sigla"

  create_table "customers", :force => true do |t|
    t.string   "name",                :limit => 40
    t.string   "surname",             :limit => 40
    t.string   "rag_soc",             :limit => 60
    t.string   "address",             :limit => 80
    t.string   "town",                :limit => 40
    t.string   "province",            :limit => 10
    t.string   "country",             :limit => 40
    t.string   "email",               :limit => 40
    t.string   "tel1",                :limit => 20
    t.string   "tel2",                :limit => 20
    t.string   "fax",                 :limit => 20
    t.string   "mobile",              :limit => 20
    t.string   "cap",                 :limit => 6
    t.date     "birth_date"
    t.string   "birth_place",         :limit => nil
    t.string   "birth_province",      :limit => nil
    t.string   "birth_country",       :limit => nil
    t.string   "cod_fisc",            :limit => 16
    t.string   "p_iva",               :limit => 15
    t.string   "cod_uff",             :limit => 5
    t.date     "contract_date"
    t.string   "contract_code",       :limit => 20
    t.integer  "user_id"
    t.integer  "gac_organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",                  :default => 0
    t.integer  "attempts",                  :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  :limit => nil
    t.string   "queue",      :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "dev_form_prods", :force => true do |t|
    t.integer  "product_id"
    t.integer  "node_id"
    t.integer  "dev_format_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dev_formats", :force => true do |t|
    t.integer  "format_id"
    t.integer  "vmax"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "form_in_id"
    t.integer  "form_out_id"
    t.string   "type",        :limit => 40
    t.integer  "node_id"
    t.string   "description", :limit => 30
    t.string   "format_type", :limit => 40
  end

  create_table "dev_param_values", :force => true do |t|
    t.integer  "node_id"
    t.integer  "dev_param_id"
    t.string   "value",        :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "enabled",                     :default => 1
    t.integer  "product_id"
  end

  add_index "dev_param_values", ["dev_param_id"], :name => "index_dev_param_values_on_dev_param_id"
  add_index "dev_param_values", ["node_id"], :name => "index_dev_param_values_on_node_id"

  create_table "dev_params", :force => true do |t|
    t.integer  "device_id"
    t.string   "description",   :limit => nil
    t.string   "cparam",        :limit => nil
    t.string   "max_value",     :limit => nil
    t.string   "min_value",     :limit => nil
    t.string   "values",        :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "code"
    t.string   "um",            :limit => nil
    t.integer  "disp_filt"
    t.integer  "special"
    t.integer  "disp_pos"
    t.integer  "prec",                         :default => 0, :null => false
    t.integer  "use_prod"
    t.integer  "basic_unit_id"
    t.string   "desc_es",       :limit => 80
    t.string   "desc_en",       :limit => 80
    t.string   "desc_ja",       :limit => 80
    t.string   "desc_de",       :limit => 80
    t.string   "desc_br",       :limit => 80
    t.string   "desc_fr",       :limit => 80
  end

  add_index "dev_params", ["code"], :name => "index_dev_params_on_code"
  add_index "dev_params", ["device_id"], :name => "index_dev_params_on_device_id"

  create_table "devices", :force => true do |t|
    t.string   "description",          :limit => nil
    t.string   "picture",              :limit => nil
    t.string   "type",                 :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color",                :limit => nil
    t.string   "img_file_name",        :limit => nil
    t.string   "img_content_type",     :limit => nil
    t.integer  "img_file_size"
    t.datetime "img_updated_at"
    t.integer  "tf_in_id"
    t.integer  "tf_out_id"
    t.integer  "manufacturer_id"
    t.string   "manufacturer",         :limit => 80
    t.integer  "project_id"
    t.string   "project",              :limit => 80
    t.string   "model",                :limit => 80
    t.string   "ser_num",              :limit => 80
    t.integer  "customer_id"
    t.string   "customer",             :limit => 80
    t.integer  "author_id"
    t.string   "picture_file_name",    :limit => nil
    t.string   "picture_content_type", :limit => nil
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "creation_date"
    t.datetime "modification_date"
    t.integer  "minor_revision"
    t.integer  "major_revision"
    t.integer  "count_revision"
    t.date     "installation_date"
    t.integer  "location_id"
    t.string   "location",             :limit => nil
    t.integer  "accessibility"
    t.integer  "prot_list_id"
    t.string   "permacode",            :limit => 10
    t.string   "desc_es",              :limit => 80
    t.string   "desc_en",              :limit => 80
    t.string   "desc_ja",              :limit => 80
    t.string   "desc_de",              :limit => 80
    t.string   "desc_br",              :limit => 80
    t.string   "desc_fr",              :limit => 80
  end

  create_table "diverters", :force => true do |t|
    t.integer  "coddivert"
    t.integer  "codprev"
    t.integer  "codmodello"
    t.integer  "codprodotto"
    t.string   "nome",            :limit => nil
    t.integer  "rendimento"
    t.integer  "canaliin"
    t.integer  "velocita"
    t.string   "vista",           :limit => nil
    t.integer  "canaliout1"
    t.integer  "canaliout2"
    t.integer  "mod_diverter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

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
    t.date     "dt_event2"
    t.date     "dt_event3"
    t.date     "dt_event4"
  end

  create_table "factories", :force => true do |t|
    t.integer  "user_id"
    t.string   "description", :limit => 80
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "form2forms", :force => true do |t|
    t.integer  "container_id"
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "form2forms", ["content_id", "container_id"], :name => "index_form2forms_on_content_id_and_container_id", :unique => true

  create_table "formats", :force => true do |t|
    t.decimal  "nl",                          :precision => 8, :scale => 2
    t.decimal  "nw",                          :precision => 8, :scale => 2
    t.decimal  "nh",                          :precision => 8, :scale => 2
    t.string   "orient",        :limit => 1
    t.string   "codice_kpl",    :limit => 16
    t.string   "codice_tmc",    :limit => 16
    t.string   "prod",          :limit => 1,                                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "typeformat_id"
  end

  create_table "formulas", :force => true do |t|
    t.integer  "plant_id"
    t.string   "description",     :limit => nil
    t.string   "formula_text",    :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unmis",           :limit => nil
    t.string   "nomevar",         :limit => nil
    t.integer  "row"
    t.integer  "formula_group"
    t.integer  "disp_filt"
    t.integer  "special"
    t.integer  "prec",                           :default => 0, :null => false
    t.string   "desc_es",         :limit => 80
    t.string   "desc_en",         :limit => 80
    t.string   "um_en",           :limit => 16
    t.string   "um_es",           :limit => 16
    t.integer  "basic_unit_type"
    t.string   "desc_ja",         :limit => 80
    t.string   "desc_de",         :limit => 80
    t.string   "desc_br",         :limit => 80
    t.string   "desc_fr",         :limit => 80
  end

  add_index "formulas", ["plant_id"], :name => "index_formulas_on_plant_id"

  create_table "gac_activations", :force => true do |t|
    t.integer  "gac_license_id"
    t.integer  "user_id"
    t.date     "date_start"
    t.date     "date_end"
    t.string   "lic_type",       :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gac_page_id"
    t.integer  "admin_level"
    t.integer  "start_state"
  end

  add_index "gac_activations", ["gac_license_id"], :name => "index_gac_activations_on_gac_license_id"
  add_index "gac_activations", ["gac_page_id"], :name => "index_gac_activations_on_gac_page_id"
  add_index "gac_activations", ["user_id"], :name => "index_gac_activations_on_user_id"

  create_table "gac_anagens", :force => true do |t|
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",           :limit => 40
    t.string   "surname",        :limit => 40
    t.string   "company_name",   :limit => 80
    t.string   "tipo_pers",      :limit => 1
    t.string   "address",        :limit => 40
    t.string   "town",           :limit => 40
    t.string   "province",       :limit => 6
    t.string   "country",        :limit => 20
    t.string   "tel1",           :limit => 20
    t.string   "tel2",           :limit => 20
    t.string   "fax",            :limit => 20
    t.string   "mobile",         :limit => 20
    t.string   "cap",            :limit => 6
    t.date     "birth_date"
    t.string   "birth_place",    :limit => 20
    t.string   "birth_province", :limit => 6
    t.string   "birth_country",  :limit => 20
    t.string   "cod_fisc",       :limit => 16
    t.string   "p_iva",          :limit => 15
    t.string   "email_1",        :limit => 40
    t.string   "email_2",        :limit => 40
    t.string   "email_3",        :limit => 40
    t.string   "web_1",          :limit => 80
    t.string   "web_2",          :limit => 80
    t.string   "web_3",          :limit => 80
    t.string   "gender",         :limit => 1
  end

  create_table "gac_app_params", :force => true do |t|
    t.string   "code",              :limit => 16
    t.string   "desc",              :limit => 80
    t.string   "grp",               :limit => 16
    t.integer  "iVal1",                                                           :default => 0
    t.integer  "iVal2",                                                           :default => 0
    t.decimal  "fVal",                             :precision => 16, :scale => 2, :default => 0.0
    t.datetime "dtVal1"
    t.datetime "dtval2"
    t.text     "sVal"
    t.integer  "parametrable_id"
    t.string   "parametrable_type", :limit => nil
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_at",                                                                       :null => false
  end

  add_index "gac_app_params", ["code"], :name => "index_gac_app_params_on_code"
  add_index "gac_app_params", ["grp"], :name => "index_gac_app_params_on_grp"
  add_index "gac_app_params", ["parametrable_type", "parametrable_id"], :name => "index_gac_app_params_on_parametrable_type_and_parametrable_id"

  create_table "gac_applications", :force => true do |t|
    t.string   "name",                :limit => 20
    t.string   "keycode",             :limit => 20
    t.text     "description"
    t.string   "version",             :limit => 8
    t.string   "logo_file_name",      :limit => nil
    t.string   "logo_content_type",   :limit => nil
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "banner_file_name",    :limit => nil
    t.string   "banner_content_type", :limit => nil
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gac_applications", ["keycode"], :name => "index_gac_applications_on_keycode"

  create_table "gac_contracts", :force => true do |t|
    t.integer  "gac_application_id"
    t.integer  "code"
    t.float    "fee"
    t.string   "name",               :limit => 80
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gac_contracts", ["gac_application_id"], :name => "index_gac_contracts_on_gac_application_id"

  create_table "gac_emails", :force => true do |t|
    t.text     "subject"
    t.text     "description",                                 :null => false
    t.string   "sub_layout",     :limit => 40
    t.string   "sender",         :limit => 80
    t.datetime "date_start"
    t.datetime "date_end"
    t.integer  "rec_limit",                    :default => 0
    t.integer  "status"
    t.integer  "gac_license_id"
    t.integer  "gac_view_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.text     "demo_address"
  end

  add_index "gac_emails", ["gac_license_id"], :name => "index_gac_emails_on_gac_license_id"
  add_index "gac_emails", ["gac_view_id"], :name => "index_gac_emails_on_gac_view_id"

  create_table "gac_items", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "picture_file_name",     :limit => nil
    t.string   "picture_content_type",  :limit => nil
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.text     "description"
    t.string   "link",                  :limit => nil
    t.integer  "mode"
    t.integer  "state"
    t.integer  "cnt_click"
    t.integer  "cnt_like"
    t.integer  "cnt_dontlike"
    t.date     "date_pub"
    t.date     "date_exp"
    t.integer  "rw"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_gac_message_id"
    t.string   "type",                  :limit => nil
    t.integer  "priority"
    t.integer  "n_align"
    t.integer  "n_decor"
    t.integer  "n_count"
    t.integer  "n_page"
    t.integer  "n_share"
    t.integer  "n_email"
    t.integer  "n_comment"
    t.integer  "gac_view_id"
    t.integer  "gac_organization_id"
    t.integer  "next_state_on_click"
    t.string   "controller",            :limit => 40
    t.string   "action",                :limit => 40
    t.text     "sparams"
    t.integer  "mparams"
    t.string   "title",                 :limit => nil
    t.string   "document_file_name",    :limit => nil
    t.string   "document_content_type", :limit => nil
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.integer  "n_order"
    t.integer  "n_list"
    t.string   "dimensions",            :limit => 30
    t.integer  "flag1",                                :default => 0
    t.integer  "flag2",                                :default => 0
    t.integer  "flag3",                                :default => 0
    t.integer  "flag4",                                :default => 0
    t.boolean  "flag_sel",                             :default => false
  end

  add_index "gac_items", ["friend_id"], :name => "index_gac_items_on_friend_id"
  add_index "gac_items", ["gac_organization_id"], :name => "index_gac_items_on_gac_organization_id"
  add_index "gac_items", ["gac_view_id"], :name => "index_gac_items_on_gac_view_id"
  add_index "gac_items", ["parent_gac_message_id"], :name => "index_gac_items_on_parent_gac_message_id"
  add_index "gac_items", ["title"], :name => "index_gac_items_on_title"
  add_index "gac_items", ["user_id"], :name => "index_gac_items_on_user_id"

  create_table "gac_licenses", :force => true do |t|
    t.integer  "gac_contract_id"
    t.integer  "gac_organization_id"
    t.date     "date_start"
    t.date     "date_end"
    t.integer  "max_users"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "keycode",             :limit => 20
  end

  add_index "gac_licenses", ["gac_contract_id"], :name => "index_gac_licenses_on_gac_contract_id"
  add_index "gac_licenses", ["gac_organization_id"], :name => "index_gac_licenses_on_gac_organization_id"
  add_index "gac_licenses", ["keycode"], :name => "index_gac_licenses_on_keycode"

  create_table "gac_organizations", :force => true do |t|
    t.string   "keycode",       :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gac_anagen_id"
  end

  add_index "gac_organizations", ["gac_anagen_id"], :name => "index_gac_organizations_on_gac_anagen_id"
  add_index "gac_organizations", ["keycode"], :name => "index_gac_organizations_on_keycode"

  create_table "gac_page_states", :force => true do |t|
    t.integer  "gac_page_id"
    t.integer  "gac_view_id"
    t.integer  "position"
    t.string   "sub_layout",  :limit => 40
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "layout",      :limit => 40
    t.integer  "flag1",                     :default => 0
    t.integer  "flag2",                     :default => 0
    t.integer  "flag3",                     :default => 0
    t.integer  "flag4",                     :default => 0
  end

  add_index "gac_page_states", ["gac_page_id"], :name => "index_gac_page_states_on_gac_page_id"
  add_index "gac_page_states", ["gac_view_id"], :name => "index_gac_page_states_on_gac_view_id"
  add_index "gac_page_states", ["state"], :name => "index_gac_page_states_on_state"

  create_table "gac_pages", :force => true do |t|
    t.string   "descriz",            :limit => 40
    t.integer  "start_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gac_application_id"
    t.string   "layout",             :limit => 40
  end

  add_index "gac_pages", ["gac_application_id"], :name => "index_gac_pages_on_gac_application_id"

  create_table "gac_recipients", :force => true do |t|
    t.text     "email_address",                              :null => false
    t.text     "name"
    t.string   "code",          :limit => 20
    t.datetime "sent"
    t.datetime "scheduled"
    t.text     "gac_errors"
    t.integer  "status",                      :default => 0, :null => false
    t.integer  "outcome"
    t.string   "skey1",         :limit => 20
    t.string   "skey2",         :limit => 20
    t.string   "skey3",         :limit => 20
    t.string   "skey4",         :limit => 20
    t.string   "skey5",         :limit => 20
    t.integer  "gac_email_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "gac_recipients", ["gac_email_id"], :name => "index_gac_recipients_on_gac_email_id"

  create_table "gac_view_templates", :force => true do |t|
    t.string   "keycode",             :limit => 20
    t.integer  "position"
    t.string   "sub_layout",          :limit => 40
    t.string   "gac_view_code",       :limit => 20
    t.string   "descriz",             :limit => 40
    t.integer  "selez_item"
    t.integer  "data_src"
    t.integer  "view_type"
    t.string   "tmpl_code",           :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "base_name",           :limit => 40
    t.integer  "gac_organization_id"
    t.integer  "gac_application_id"
  end

  add_index "gac_view_templates", ["gac_application_id"], :name => "index_gac_view_templates_on_gac_application_id"
  add_index "gac_view_templates", ["gac_view_code"], :name => "index_gac_view_templates_on_gac_view_code"
  add_index "gac_view_templates", ["keycode"], :name => "index_gac_view_templates_on_keycode"

  create_table "gac_views", :force => true do |t|
    t.string   "descriz",            :limit => 40
    t.integer  "view_type"
    t.integer  "data_src"
    t.integer  "selez_item"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "keycode",            :limit => 20
    t.string   "tmpl_code",          :limit => 20
    t.string   "textfile",           :limit => 80
    t.integer  "gac_application_id"
  end

  add_index "gac_views", ["keycode"], :name => "index_gac_views_on_keycode"

  create_table "helps", :force => true do |t|
    t.string   "controller", :limit => nil
    t.string   "action",     :limit => nil
    t.string   "params",     :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_items", :force => true do |t|
    t.integer  "invoice_id"
    t.string   "descrizione",         :limit => 80
    t.decimal  "qta",                                :precision => 10, :scale => 2
    t.string   "um",                  :limit => nil
    t.date     "date_start"
    t.date     "date_end"
    t.decimal  "unitario",                           :precision => 12, :scale => 4
    t.decimal  "totale",                             :precision => 12, :scale => 4
    t.decimal  "perciva",                            :precision => 12, :scale => 2
    t.string   "codiva",              :limit => 10
    t.string   "rif_amministrazione", :limit => 20
    t.integer  "user_id"
    t.integer  "gac_organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_totals", :force => true do |t|
    t.decimal  "perciva",                           :precision => 10, :scale => 2
    t.string   "codiva",              :limit => 10
    t.decimal  "imponibile",                        :precision => 12, :scale => 2
    t.decimal  "imposta",                           :precision => 12, :scale => 2
    t.decimal  "totale",                            :precision => 12, :scale => 2
    t.string   "esigibilita_iva",     :limit => 1
    t.integer  "invoice_id"
    t.integer  "user_id"
    t.integer  "gac_organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", :force => true do |t|
    t.string   "divisa",              :limit => 5
    t.date     "date_doc"
    t.date     "date_scad"
    t.integer  "num_doc"
    t.integer  "art73"
    t.integer  "customer_id"
    t.decimal  "total",                            :precision => 12, :scale => 2
    t.integer  "gac_organization_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "user_id"
    t.integer  "plant_id"
    t.integer  "friend_id"
    t.string   "picture_file_name",    :limit => nil
    t.string   "picture_content_type", :limit => nil
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.text     "description"
    t.text     "link"
    t.integer  "mode"
    t.integer  "state"
    t.integer  "cnt_click"
    t.integer  "cnt_like"
    t.integer  "cnt_dontlike"
    t.date     "date_pub"
    t.date     "date_exp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                 :limit => nil
    t.integer  "priority"
    t.integer  "n_align"
    t.integer  "n_decor"
    t.integer  "n_count"
    t.integer  "n_page"
    t.integer  "n_context"
    t.integer  "n_share"
    t.integer  "n_email"
    t.integer  "n_comment"
    t.integer  "parent_message_id"
  end

  add_index "items", ["friend_id"], :name => "index_items_on_friend_id"
  add_index "items", ["plant_id"], :name => "index_items_on_plant_id"
  add_index "items", ["user_id"], :name => "index_items_on_user_id"

  create_table "items_page_views", :id => false, :force => true do |t|
    t.integer "item_id"
    t.integer "page_view_id"
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
    t.integer  "state",                      :default => 1
  end

  create_table "languages", :force => true do |t|
    t.string   "name",       :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "locale",     :limit => nil
  end

  add_index "languages", ["locale"], :name => "index_languages_on_locale"

  create_table "link_types", :force => true do |t|
    t.string   "description", :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.integer  "article_id"
    t.integer  "category_id"
    t.string   "description",      :limit => nil
    t.string   "url",              :limit => nil
    t.string   "url_thumb",        :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "link_type_id"
    t.string   "href",             :limit => nil
    t.date     "date_start"
    t.date     "date_end"
    t.string   "img_file_name",    :limit => nil
    t.string   "img_content_type", :limit => nil
    t.integer  "img_file_size"
    t.datetime "img_updated_at"
    t.text     "long_desc"
  end

  add_index "links", ["article_id"], :name => "index_links_on_article_id"
  add_index "links", ["category_id"], :name => "index_links_on_category_id"
  add_index "links", ["link_type_id"], :name => "index_links_on_link_type_id"

  create_table "lists", :force => true do |t|
    t.string  "permalink", :limit => 40
    t.integer "parent_id"
  end

  create_table "lists_users", :id => false, :force => true do |t|
    t.integer "list_id"
    t.integer "user_id"
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

  create_table "mcloud_answer_types", :force => true do |t|
    t.string   "code",        :limit => 2
    t.text     "description"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "mcloud_answer_types", ["code"], :name => "index_mcloud_answer_types_on_code"

  create_table "mcloud_answers", :force => true do |t|
    t.integer  "position"
    t.integer  "ladder_id"
    t.integer  "status"
    t.text     "content"
    t.integer  "content_code_id"
    t.text     "notes"
    t.integer  "answer_type_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "mcloud_answers", ["answer_type_id"], :name => "index_mcloud_answers_on_answer_type_id"
  add_index "mcloud_answers", ["content_code_id"], :name => "index_mcloud_answers_on_content_code_id"
  add_index "mcloud_answers", ["ladder_id"], :name => "index_mcloud_answers_on_ladder_id"
  add_index "mcloud_answers", ["position"], :name => "index_mcloud_answers_on_position"
  add_index "mcloud_answers", ["status"], :name => "index_mcloud_answers_on_status"

  create_table "mcloud_arcs", :force => true do |t|
    t.integer  "map_id"
    t.integer  "node_in_id"
    t.integer  "node_out_id"
    t.integer  "strength"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "mcloud_arcs", ["map_id"], :name => "index_mcloud_arcs_on_map_id"
  add_index "mcloud_arcs", ["node_in_id"], :name => "index_mcloud_arcs_on_node_in_id"
  add_index "mcloud_arcs", ["node_out_id"], :name => "index_mcloud_arcs_on_node_out_id"

  create_table "mcloud_content_codes", :force => true do |t|
    t.integer  "answer_type_id"
    t.integer  "parent_id"
    t.integer  "project_id"
    t.text     "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "code"
  end

  add_index "mcloud_content_codes", ["answer_type_id"], :name => "index_mcloud_content_codes_on_answer_type_id"
  add_index "mcloud_content_codes", ["description"], :name => "index_mcloud_content_codes_on_description"
  add_index "mcloud_content_codes", ["parent_id"], :name => "index_mcloud_content_codes_on_parent_id"
  add_index "mcloud_content_codes", ["project_id"], :name => "index_mcloud_content_codes_on_project_id"

  create_table "mcloud_demo_code_values", :force => true do |t|
    t.integer  "subject_id"
    t.integer  "demo_code_id"
    t.string   "value",        :limit => nil
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "mcloud_demo_codes", :force => true do |t|
    t.text     "description"
    t.integer  "project_id"
    t.string   "query_format", :limit => 1, :default => "T"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "mcloud_demo_codes", ["project_id"], :name => "index_mcloud_demo_codes_on_project_id"

  create_table "mcloud_demo_codes_subjects", :id => false, :force => true do |t|
    t.integer "demo_code_id", :null => false
    t.integer "subject_id",   :null => false
  end

  add_index "mcloud_demo_codes_subjects", ["demo_code_id", "subject_id"], :name => "index_mcloud_demo_codes_subjects_on_demo_code_id_and_subject_id"
  add_index "mcloud_demo_codes_subjects", ["subject_id", "demo_code_id"], :name => "index_mcloud_demo_codes_subjects_on_subject_id_and_demo_code_id"

  create_table "mcloud_ladder_code_values", :force => true do |t|
    t.integer  "ladder_id"
    t.integer  "ladder_code_id"
    t.string   "value",          :limit => nil
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "mcloud_ladder_codes", :force => true do |t|
    t.text     "description"
    t.integer  "project_id"
    t.string   "query_format", :limit => 1, :default => "T"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "mcloud_ladder_codes", ["project_id"], :name => "index_mcloud_ladder_codes_on_project_id"

  create_table "mcloud_ladder_codes_ladders", :id => false, :force => true do |t|
    t.integer "ladder_code_id", :null => false
    t.integer "ladder_id",      :null => false
  end

  add_index "mcloud_ladder_codes_ladders", ["ladder_code_id", "ladder_id"], :name => "lc_lad"
  add_index "mcloud_ladder_codes_ladders", ["ladder_id", "ladder_code_id"], :name => "lad_lc"

  create_table "mcloud_ladders", :force => true do |t|
    t.integer  "position"
    t.integer  "subject_id"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "mcloud_ladders", ["position"], :name => "index_mcloud_ladders_on_position"
  add_index "mcloud_ladders", ["status"], :name => "index_mcloud_ladders_on_status"
  add_index "mcloud_ladders", ["subject_id"], :name => "index_mcloud_ladders_on_subject_id"

  create_table "mcloud_maps", :force => true do |t|
    t.integer  "cut_off1"
    t.integer  "cut_off2"
    t.integer  "cut_off3"
    t.integer  "cut_off4"
    t.integer  "cut_off5"
    t.integer  "cut_off6"
    t.integer  "project_id"
    t.string   "description",   :limit => 80
    t.text     "code_filter"
    t.text     "demo_filter"
    t.text     "ladder_filter"
    t.text     "note"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "mcloud_maps", ["project_id"], :name => "index_mcloud_maps_on_project_id"

  create_table "mcloud_nodes", :force => true do |t|
    t.integer  "map_id"
    t.integer  "content_code_id"
    t.integer  "x"
    t.integer  "y"
    t.string   "label",           :limit => 40
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.decimal  "vx",                            :precision => 12, :scale => 8
    t.decimal  "vy",                            :precision => 12, :scale => 8
    t.integer  "cc_code"
    t.integer  "nr"
    t.decimal  "psub",                          :precision => 4,  :scale => 2
    t.integer  "nsub"
    t.string   "ntype",           :limit => 8
  end

  create_table "mcloud_project_shares", :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.integer "mode",       :default => 0
  end

  add_index "mcloud_project_shares", ["project_id"], :name => "index_mcloud_project_shares_on_project_id"
  add_index "mcloud_project_shares", ["user_id"], :name => "index_mcloud_project_shares_on_user_id"

  create_table "mcloud_projects", :force => true do |t|
    t.string   "code",           :limit => 40
    t.string   "title",          :limit => 40
    t.text     "description"
    t.text     "notes"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "est_end_date"
    t.integer  "status"
    t.integer  "fpublic"
    t.integer  "major_version"
    t.integer  "minor_version"
    t.integer  "parent_id"
    t.integer  "owner_id"
    t.integer  "gac_license_id"
    t.integer  "gac_view_id"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.integer  "abs_level",                    :default => 6
    t.string   "ac_color",       :limit => 20, :default => "#00bfff"
    t.string   "af_color",       :limit => 20, :default => "#00bf7f"
    t.string   "cf_color",       :limit => 20, :default => "#ff8000"
    t.string   "cp_color",       :limit => 20, :default => "#ff8080"
    t.string   "vi_color",       :limit => 20, :default => "#ffff00"
    t.string   "vt_color",       :limit => 20, :default => "#ffff80"
  end

  add_index "mcloud_projects", ["code"], :name => "index_mcloud_projects_on_code"
  add_index "mcloud_projects", ["gac_license_id"], :name => "index_mcloud_projects_on_gac_license_id"
  add_index "mcloud_projects", ["owner_id"], :name => "index_mcloud_projects_on_owner_id"
  add_index "mcloud_projects", ["parent_id"], :name => "index_mcloud_projects_on_parent_id"
  add_index "mcloud_projects", ["status"], :name => "index_mcloud_projects_on_status"

  create_table "mcloud_projects_tags", :id => false, :force => true do |t|
    t.integer "project_id", :null => false
    t.integer "tag_id",     :null => false
  end

  add_index "mcloud_projects_tags", ["project_id", "tag_id"], :name => "index_mcloud_projects_tags_on_project_id_and_tag_id"
  add_index "mcloud_projects_tags", ["tag_id", "project_id"], :name => "index_mcloud_projects_tags_on_tag_id_and_project_id"

  create_table "mcloud_subjects", :force => true do |t|
    t.integer  "position"
    t.integer  "project_id"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "mcloud_subjects", ["position"], :name => "index_mcloud_subjects_on_position"
  add_index "mcloud_subjects", ["project_id"], :name => "index_mcloud_subjects_on_project_id"
  add_index "mcloud_subjects", ["status"], :name => "index_mcloud_subjects_on_status"

  create_table "mcloud_tags", :force => true do |t|
    t.integer  "user_id"
    t.string   "name",        :limit => 20
    t.text     "description"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "mcloud_tags", ["name"], :name => "index_mcloud_tags_on_name"
  add_index "mcloud_tags", ["user_id"], :name => "index_mcloud_tags_on_user_id"

  create_table "mtour_allotments", :force => true do |t|
    t.string   "tipo",           :limit => 1
    t.string   "zona",           :limit => 4
    t.string   "categ",          :limit => 1
    t.integer  "cod_serv"
    t.date     "data_inizio"
    t.date     "data_fine"
    t.string   "tipologia",      :limit => nil
    t.integer  "numero_camere"
    t.integer  "numero_camere2"
    t.integer  "cut_off"
    t.integer  "gp_category_id"
    t.integer  "gp_zone_id"
    t.integer  "service_id"
    t.integer  "gac_license_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "mtour_allotments", ["gac_license_id"], :name => "index_mtour_allotments_on_gac_license_id"
  add_index "mtour_allotments", ["gp_category_id"], :name => "index_mtour_allotments_on_gp_category_id"
  add_index "mtour_allotments", ["gp_zone_id"], :name => "index_mtour_allotments_on_gp_zone_id"
  add_index "mtour_allotments", ["service_id"], :name => "index_mtour_allotments_on_service_id"

  create_table "mtour_anagens", :force => true do |t|
    t.integer  "gac_license_id"
    t.integer  "codice"
    t.string   "categor",              :limit => 4
    t.string   "nome",                 :limit => 40
    t.string   "cap",                  :limit => 5
    t.integer  "codloc"
    t.string   "localita",             :limit => 30
    t.string   "prov",                 :limit => 2
    t.string   "naz",                  :limit => 5
    t.string   "indiriz",              :limit => 30
    t.string   "telef",                :limit => 20
    t.string   "fax",                  :limit => 20
    t.string   "telex",                :limit => 20
    t.string   "respons",              :limit => 20
    t.text     "note"
    t.string   "codfisc",              :limit => 16
    t.string   "partiva",              :limit => 11
    t.date     "dataincontro"
    t.string   "occasione",            :limit => 40
    t.string   "azienda",              :limit => 40
    t.string   "posizione",            :limit => 40
    t.integer  "dare"
    t.integer  "avere"
    t.integer  "fido"
    t.integer  "rischio"
    t.string   "allegati",             :limit => 40
    t.integer  "gest1"
    t.string   "tipo",                 :limit => 1
    t.string   "codpag",               :limit => 4
    t.text     "note2"
    t.string   "nome2",                :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                 :limit => 20
    t.text     "email"
    t.string   "picture_file_name",    :limit => nil
    t.string   "picture_content_type", :limit => nil
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.decimal  "provvig",                             :precision => 12, :scale => 2
    t.string   "pec",                  :limit => 64
    t.string   "codice_ident",         :limit => 16
    t.string   "nation",               :limit => 2
  end

  add_index "mtour_anagens", ["codice"], :name => "index_mtour_anagens_on_codice"
  add_index "mtour_anagens", ["gac_license_id"], :name => "index_mtour_anagens_on_gac_license_id"
  add_index "mtour_anagens", ["tipo"], :name => "index_mtour_anagens_on_tipo"

  create_table "mtour_bookings", :force => true do |t|
    t.string   "codice_pratica",      :limit => 12
    t.integer  "codice_prenotazione"
    t.string   "tipo",                :limit => 1
    t.string   "zona",                :limit => 4
    t.string   "categ",               :limit => 1
    t.integer  "cod_serv"
    t.date     "data_inizio"
    t.date     "data_fine"
    t.string   "tipologia",           :limit => 4
    t.integer  "numero_camere"
    t.date     "data_prenotazione"
    t.integer  "pax"
    t.string   "codice_trattamento",  :limit => 10
    t.string   "codice_sistemazione", :limit => 10
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "gac_license_id"
    t.integer  "tesprat_id"
    t.integer  "gp_zone_id"
    t.integer  "service_id"
    t.integer  "gp_category_id"
    t.integer  "gp_room_type_id"
    t.integer  "gp_board_type_id"
  end

  create_table "mtour_docprats", :force => true do |t|
    t.integer  "tesprat_id"
    t.integer  "gac_license_id"
    t.string   "desc_doc",        :limit => 32
    t.integer  "type_doc"
    t.string   "pref_num_doc",    :limit => 4
    t.integer  "num_doc"
    t.date     "dt_doc"
    t.date     "dt_pag"
    t.integer  "caus_doc"
    t.integer  "cod_cli"
    t.decimal  "imponibile",                    :precision => 12, :scale => 2
    t.decimal  "imposta",                       :precision => 12, :scale => 2
    t.integer  "cod_iva"
    t.string   "desc_iva",        :limit => 20
    t.decimal  "aliquota",                      :precision => 6,  :scale => 2
    t.decimal  "acconto",                       :precision => 12, :scale => 2
    t.decimal  "saldo",                         :precision => 12, :scale => 2
    t.integer  "cod_pag"
    t.integer  "flag_iban",                                                    :default => 0
    t.integer  "stato",                                                        :default => 0
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
    t.text     "descriz"
    t.text     "annotaz"
    t.text     "quotes"
    t.date     "dt_fatt_elett"
    t.integer  "prog_fatt_elett",                                              :default => 0
    t.integer  "usa_bollo",                                                    :default => 0
  end

  add_index "mtour_docprats", ["cod_cli"], :name => "index_mtour_docprats_on_cod_cli"
  add_index "mtour_docprats", ["gac_license_id"], :name => "index_mtour_docprats_on_gac_license_id"
  add_index "mtour_docprats", ["tesprat_id"], :name => "index_mtour_docprats_on_tesprat_id"

  create_table "mtour_gp_tables", :force => true do |t|
    t.string   "type",        :limit => 20
    t.string   "code",        :limit => 10
    t.string   "description", :limit => 80
    t.integer  "period"
    t.integer  "flag"
    t.integer  "pax"
    t.string   "serv_type",   :limit => 1
    t.string   "acco_type",   :limit => 8
    t.integer  "pagam_type"
    t.integer  "use_zone"
    t.integer  "use_board"
    t.integer  "use_serv"
    t.integer  "use_categ"
    t.string   "price_type",  :limit => 1
    t.string   "option",      :limit => 20
    t.date     "dt_start"
    t.date     "dt_end"
    t.decimal  "fvalue",                    :precision => 12, :scale => 2
    t.decimal  "svalue"
    t.integer  "ivalue"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.string   "geo_coord",   :limit => 80
    t.string   "region_desc", :limit => 80
    t.integer  "region_code"
  end

  add_index "mtour_gp_tables", ["code"], :name => "index_mtour_gp_tables_on_code"
  add_index "mtour_gp_tables", ["description"], :name => "index_mtour_gp_tables_on_description"
  add_index "mtour_gp_tables", ["serv_type"], :name => "index_mtour_gp_tables_on_serv_type"
  add_index "mtour_gp_tables", ["type"], :name => "index_mtour_gp_tables_on_type"

  create_table "mtour_opeaereos", :force => true do |t|
    t.string   "codice_pratica", :limit => 12
    t.integer  "riga"
    t.string   "volo",           :limit => 8
    t.string   "partenza",       :limit => 3
    t.string   "arrivo",         :limit => 3
    t.date     "data_partenza"
    t.date     "data_arrivo"
    t.string   "ora_arrivo",     :limit => 20
    t.string   "ora_partenza",   :limit => 20
    t.date     "data_conferma"
    t.string   "note",           :limit => 40
    t.string   "note2",          :limit => 40
    t.integer  "tesprat_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "gac_license_id"
    t.integer  "grp",                          :default => 1
  end

  add_index "mtour_opeaereos", ["codice_pratica"], :name => "index_mtour_opeaereos_on_codice_pratica"
  add_index "mtour_opeaereos", ["riga"], :name => "index_mtour_opeaereos_on_riga"
  add_index "mtour_opeaereos", ["tesprat_id"], :name => "index_mtour_opeaereos_on_tesprat_id"

  create_table "mtour_partecips", :force => true do |t|
    t.string   "codice_pratica",      :limit => 12
    t.integer  "codice_partecipante"
    t.string   "nome",                :limit => 50
    t.string   "indirizzo",           :limit => 40
    t.string   "localita",            :limit => 40
    t.string   "sesso",               :limit => 1
    t.string   "codice_professione",  :limit => 4
    t.string   "codice_provenienza",  :limit => 4
    t.string   "tessera",             :limit => 4
    t.date     "data_nascita"
    t.date     "data_prenotazione"
    t.decimal  "totale_ordinato",                   :precision => 12, :scale => 2
    t.decimal  "totale_pagato",                     :precision => 12, :scale => 2
    t.integer  "codice_pagante"
    t.string   "telefono",            :limit => 20
    t.string   "note",                :limit => 30
    t.integer  "codice_anag"
    t.integer  "provvig"
    t.integer  "codice_anapers"
    t.integer  "tesprat_id"
    t.integer  "anagen_id"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  add_index "mtour_partecips", ["anagen_id"], :name => "index_mtour_partecips_on_anagen_id"
  add_index "mtour_partecips", ["codice_anag"], :name => "index_mtour_partecips_on_codice_anag"
  add_index "mtour_partecips", ["codice_partecipante"], :name => "index_mtour_partecips_on_codice_partecipante"
  add_index "mtour_partecips", ["codice_pratica"], :name => "index_mtour_partecips_on_codice_pratica"
  add_index "mtour_partecips", ["tesprat_id"], :name => "index_mtour_partecips_on_tesprat_id"

  create_table "mtour_partecips_rigprats", :id => false, :force => true do |t|
    t.integer "partecip_id"
    t.integer "rigprat_id"
  end

  create_table "mtour_phrases", :force => true do |t|
    t.integer  "gac_license_id"
    t.string   "group",          :limit => 16
    t.string   "code",           :limit => 16
    t.text     "words"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "mtour_phrases", ["code"], :name => "index_mtour_phrases_on_code"
  add_index "mtour_phrases", ["gac_license_id"], :name => "index_mtour_phrases_on_gac_license_id"
  add_index "mtour_phrases", ["group"], :name => "index_mtour_phrases_on_group"

  create_table "mtour_phrases_tesprats", :id => false, :force => true do |t|
    t.integer "phrase_id"
    t.integer "tesprat_id"
  end

  add_index "mtour_phrases_tesprats", ["phrase_id"], :name => "index_mtour_phrases_tesprats_on_phrase_id"
  add_index "mtour_phrases_tesprats", ["tesprat_id"], :name => "index_mtour_phrases_tesprats_on_tesprat_id"

  create_table "mtour_pnrs", :force => true do |t|
    t.string   "codice_pratica", :limit => 12
    t.integer  "riga"
    t.string   "pnr",            :limit => 40
    t.integer  "gac_license_id"
    t.integer  "tesprat_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "mtour_prices", :force => true do |t|
    t.string   "tipo",             :limit => 1
    t.string   "zona",             :limit => 10
    t.string   "categ",            :limit => 1
    t.integer  "cod_serv",                                                      :default => 0
    t.string   "listino",          :limit => 2
    t.string   "trattam",          :limit => 10
    t.string   "sistemaz",         :limit => 10
    t.date     "data_inizio"
    t.date     "data_fine"
    t.decimal  "prezzo",                         :precision => 12, :scale => 2, :default => 0.0
    t.integer  "pax",                                                           :default => 0
    t.decimal  "extra",                          :precision => 12, :scale => 2, :default => 0.0
    t.integer  "grat1",                                                         :default => 0
    t.integer  "grat2",                                                         :default => 0
    t.string   "tipo_prezzom",     :limit => 1
    t.string   "valuta",           :limit => 4
    t.text     "note"
    t.integer  "gac_license_id"
    t.integer  "service_id"
    t.integer  "gp_room_type_id"
    t.integer  "gp_board_type_id"
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_at",                                                                       :null => false
    t.boolean  "flag_sel",                                                      :default => false
  end

  add_index "mtour_prices", ["gac_license_id"], :name => "index_mtour_prices_on_gac_license_id"
  add_index "mtour_prices", ["gp_board_type_id"], :name => "index_mtour_prices_on_gp_board_type_id"
  add_index "mtour_prices", ["gp_room_type_id"], :name => "index_mtour_prices_on_gp_room_type_id"
  add_index "mtour_prices", ["service_id"], :name => "index_mtour_prices_on_service_id"

  create_table "mtour_psrs", :force => true do |t|
    t.string   "codice_pratica", :limit => 12
    t.integer  "riga"
    t.integer  "conj",           :limit => 8
    t.integer  "sn",             :limit => 8
    t.integer  "ck",             :limit => 8
    t.decimal  "fare",                         :precision => 12, :scale => 2
    t.decimal  "tax",                          :precision => 12, :scale => 2
    t.decimal  "perc",                         :precision => 12, :scale => 2
    t.decimal  "amount",                       :precision => 12, :scale => 2
    t.decimal  "payed",                        :precision => 12, :scale => 2
    t.string   "sector",         :limit => 80
    t.string   "document",       :limit => 40
    t.integer  "sn2",            :limit => 8
    t.integer  "ck2",            :limit => 8
    t.date     "data_emissione"
    t.string   "stato",          :limit => 1
    t.date     "data_partenza"
    t.integer  "gac_license_id"
    t.integer  "tesprat_id"
    t.datetime "created_at",                                                                 :null => false
    t.datetime "updated_at",                                                                 :null => false
    t.integer  "psr_form"
    t.integer  "fatturazione",                                                :default => 0
  end

  add_index "mtour_psrs", ["gac_license_id"], :name => "index_mtour_psrs_on_gac_license_id"
  add_index "mtour_psrs", ["tesprat_id"], :name => "index_mtour_psrs_on_tesprat_id"

  create_table "mtour_rigcoms", :force => true do |t|
    t.integer  "conto"
    t.date     "data_com"
    t.string   "rif",            :limit => 8
    t.integer  "riga"
    t.string   "cod_prat",       :limit => 12
    t.string   "stato",          :limit => 1
    t.string   "servizio",       :limit => 80
    t.string   "periodo",        :limit => 80
    t.date     "data_arr"
    t.date     "data_par"
    t.string   "tipo",           :limit => 4
    t.string   "trattamento",    :limit => 80
    t.string   "sistemazione",   :limit => 80
    t.string   "pnr",            :limit => 8
    t.text     "opa"
    t.text     "pax"
    t.text     "descrizione"
    t.text     "note"
    t.integer  "tescom_id"
    t.integer  "gac_license_id"
    t.integer  "tesprat_id"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.boolean  "flag_sel",                     :default => false
  end

  add_index "mtour_rigcoms", ["gac_license_id"], :name => "index_mtour_rigcoms_on_gac_license_id"
  add_index "mtour_rigcoms", ["tescom_id"], :name => "index_mtour_rigcoms_on_tescom_id"
  add_index "mtour_rigcoms", ["tesprat_id"], :name => "index_mtour_rigcoms_on_tesprat_id"

  create_table "mtour_rigprats", :force => true do |t|
    t.string   "codice_pratica",          :limit => 12
    t.integer  "riga",                                                                 :default => 0
    t.date     "data_finale"
    t.string   "tipo_servizio",           :limit => 10
    t.string   "zona_servizio",           :limit => 4
    t.string   "categoria_servizio",      :limit => 10
    t.integer  "codice_servizio",                                                      :default => 0
    t.string   "codice_trattamento",      :limit => 10
    t.string   "codice_sistemazione",     :limit => 10
    t.integer  "numero_pax",                                                           :default => 0
    t.integer  "numero_stanze",                                                        :default => 0
    t.integer  "numero_notti",                                                         :default => 0
    t.integer  "numero_paganti",                                                       :default => 0
    t.integer  "codice_fornitore",                                                     :default => 0
    t.decimal  "provvigione",                           :precision => 5,  :scale => 2, :default => 0.0
    t.decimal  "prezzo_acquisto",                       :precision => 12, :scale => 5, :default => 0.0
    t.string   "valuta_acquisto",         :limit => 4
    t.decimal  "cambio_acquisto",                       :precision => 12, :scale => 5, :default => 0.0
    t.decimal  "prezzo_vendita",                        :precision => 12, :scale => 5, :default => 0.0
    t.string   "valuta_vendita",          :limit => 4
    t.decimal  "cambio_vendita",                        :precision => 12, :scale => 5, :default => 0.0
    t.decimal  "totale_acquistato",                     :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "totale_venduto",                        :precision => 12, :scale => 2, :default => 0.0
    t.string   "tipo_prezzo",             :limit => 10
    t.date     "data_prenotazione"
    t.text     "descrizione"
    t.string   "note",                    :limit => 4
    t.string   "opzioni",                 :limit => 8
    t.string   "codice_listino",          :limit => 2
    t.decimal  "quota_persona",                         :precision => 12, :scale => 2, :default => 0.0
    t.string   "localita",                :limit => 30
    t.string   "tipo_prezzo_ven",         :limit => 10
    t.integer  "cod_pag_for",                                                          :default => 0
    t.integer  "max_room",                                                             :default => 0
    t.integer  "max_pax",                                                              :default => 0
    t.string   "combinazione",            :limit => 8
    t.integer  "codice_prenotazione",                                                  :default => 0
    t.integer  "numero_notti_free",                                                    :default => 0
    t.integer  "cod_corrisp",                                                          :default => 0
    t.text     "note2"
    t.integer  "tesprat_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gac_license_id"
    t.integer  "service_id"
    t.date     "data_iniziale"
    t.text     "note2_ex"
    t.text     "note3_ex"
    t.text     "note4_ex"
    t.integer  "numero_gratuita",                                                      :default => 0
    t.string   "desc_trattam",            :limit => 80
    t.string   "desc_sistem",             :limit => 80
    t.integer  "service_day_id"
    t.text     "note_voucher"
    t.integer  "service_day_rigprat_id"
    t.date     "service_day_data_inizio"
    t.boolean  "flag_sel",                                                             :default => false
    t.text     "note_foglio"
    t.string   "stato_trasm",             :limit => 1
    t.integer  "booking_id"
    t.integer  "flag_val_price",                                                       :default => 0
    t.integer  "st_pren",                                                              :default => 0
    t.integer  "flag_nr_pax",                                                          :default => 0
    t.boolean  "sel_canc",                                                             :default => false
  end

  add_index "mtour_rigprats", ["booking_id"], :name => "index_mtour_rigprats_on_booking_id"
  add_index "mtour_rigprats", ["codice_pratica"], :name => "index_mtour_rigprats_on_codice_pratica"
  add_index "mtour_rigprats", ["riga"], :name => "index_mtour_rigprats_on_riga"
  add_index "mtour_rigprats", ["tesprat_id"], :name => "index_mtour_rigprats_on_tesprat_id"

  create_table "mtour_service_days", :force => true do |t|
    t.string   "title",                :limit => 80
    t.text     "description"
    t.integer  "day"
    t.text     "zone_list"
    t.integer  "linked_service_id"
    t.integer  "service_id"
    t.string   "picture_file_name",    :limit => nil
    t.string   "picture_content_type", :limit => nil
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "opz_serv",             :limit => 20
  end

  add_index "mtour_service_days", ["service_id"], :name => "index_mtour_service_days_on_service_id"

  create_table "mtour_services", :force => true do |t|
    t.string   "serv_type",             :limit => 1
    t.string   "zone",                  :limit => 10
    t.string   "categ",                 :limit => 1
    t.integer  "cod_serv",                             :default => 0
    t.text     "description"
    t.string   "nominativo",            :limit => 80
    t.integer  "cod_forn",                             :default => 0
    t.text     "note"
    t.text     "note2"
    t.text     "address"
    t.integer  "cod_loc",                              :default => 0
    t.string   "localita",              :limit => 80
    t.string   "prov",                  :limit => 10
    t.string   "country",               :limit => 5
    t.string   "cap",                   :limit => 5
    t.string   "tel1",                  :limit => 20
    t.string   "fax",                   :limit => 20
    t.string   "telex",                 :limit => 20
    t.string   "email",                 :limit => 60
    t.text     "url"
    t.string   "valuta",                :limit => 10
    t.string   "colleg",                :limit => 20
    t.string   "flag_corrisp",          :limit => 1
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.integer  "anagen_id"
    t.integer  "gp_zone_id"
    t.integer  "gac_license_id"
    t.integer  "gp_category_id"
    t.text     "desc2"
    t.string   "website",               :limit => 80
    t.string   "arrive_time",           :limit => 10
    t.string   "dept_time",             :limit => 10
    t.integer  "fpub",                                 :default => 0
    t.integer  "fhom",                                 :default => 0
    t.datetime "pdate_from"
    t.datetime "pdate_to"
    t.string   "geo_coord",             :limit => 80
    t.integer  "gac_view_id"
    t.text     "title"
    t.string   "categ2",                :limit => nil
    t.integer  "n_order",                              :default => 0
    t.text     "quotes"
    t.text     "dates"
    t.text     "youtube_video_url"
    t.integer  "best_alias_service_id"
  end

  add_index "mtour_services", ["categ"], :name => "index_mtour_services_on_categ"
  add_index "mtour_services", ["cod_serv"], :name => "index_mtour_services_on_cod_serv"
  add_index "mtour_services", ["gac_license_id"], :name => "index_mtour_services_on_gac_license_id"
  add_index "mtour_services", ["gp_category_id"], :name => "index_mtour_services_on_gp_category_id"
  add_index "mtour_services", ["gp_zone_id"], :name => "index_mtour_services_on_gp_zone_id"
  add_index "mtour_services", ["serv_type"], :name => "index_mtour_services_on_serv_type"
  add_index "mtour_services", ["zone"], :name => "index_mtour_services_on_zone"

  create_table "mtour_tescoms", :force => true do |t|
    t.integer  "conto"
    t.date     "data_com"
    t.string   "rif",            :limit => 8
    t.string   "from",           :limit => 20
    t.integer  "gac_license_id"
    t.integer  "anagen_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "mtour_tescoms", ["anagen_id"], :name => "index_mtour_tescoms_on_anagen_id"
  add_index "mtour_tescoms", ["conto"], :name => "index_mtour_tescoms_on_conto"
  add_index "mtour_tescoms", ["data_com"], :name => "index_mtour_tescoms_on_data_com"
  add_index "mtour_tescoms", ["gac_license_id"], :name => "index_mtour_tescoms_on_gac_license_id"
  add_index "mtour_tescoms", ["rif"], :name => "index_mtour_tescoms_on_rif"

  create_table "mtour_tesprats", :force => true do |t|
    t.string   "codice_pratica",      :limit => 12
    t.integer  "codice_cliente",                                                   :default => 0
    t.date     "data_preventivo"
    t.date     "data_conferma"
    t.date     "data_partenza"
    t.date     "data_ritorno"
    t.string   "descrizione",         :limit => 80
    t.integer  "num_pax",                                                          :default => 0
    t.string   "tipo_pratica",        :limit => 2
    t.decimal  "provvigione",                       :precision => 5,  :scale => 2, :default => 0.0
    t.string   "codice_zona",         :limit => 4
    t.string   "stato_pratica",       :limit => 1
    t.decimal  "sconto",                            :precision => 5,  :scale => 2, :default => 0.0
    t.string   "codice_pagamento",    :limit => 4
    t.decimal  "tot_ord_cli",                       :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tot_pag_cli",                       :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tot_fat_cli",                       :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tot_ord_for",                       :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tot_pag_for",                       :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tot_fat_for",                       :precision => 12, :scale => 2, :default => 0.0
    t.string   "nome_cliente",        :limit => 30
    t.string   "codice_listino",      :limit => 30
    t.integer  "codice_operatore",                                                 :default => 0
    t.decimal  "ricarico",                          :precision => 5,  :scale => 2, :default => 0.0
    t.text     "note"
    t.date     "data_fiss_cambio"
    t.string   "referente",           :limit => 40
    t.date     "data_scad_pagam"
    t.string   "stato_trasm",         :limit => 1
    t.date     "data_trasm"
    t.decimal  "tot_ord_provv",                     :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tot_fat_provv",                     :precision => 12, :scale => 2, :default => 0.0
    t.decimal  "tot_pag_provv",                     :precision => 12, :scale => 2, :default => 0.0
    t.string   "valuta_conto",        :limit => 4
    t.date     "data_certif"
    t.string   "num_certif",          :limit => 20
    t.string   "numero_sim",          :limit => 20
    t.string   "pnr1",                :limit => 40
    t.string   "pnr2",                :limit => 40
    t.integer  "anagen_id"
    t.integer  "gac_license_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "note_agency"
    t.text     "note_quote"
    t.boolean  "show_price",                                                       :default => true
    t.boolean  "show_img",                                                         :default => true
    t.boolean  "show_maps"
    t.boolean  "show_tour"
    t.boolean  "exp_services",                                                     :default => true
    t.decimal  "recharge",                          :precision => 5,  :scale => 2, :default => 0.0
    t.integer  "fpub",                                                             :default => 0
    t.string   "destinaz",            :limit => 40
    t.integer  "gp_zone_id"
    t.string   "tipo_viaggio",        :limit => 4
    t.string   "vettore",             :limit => 4
    t.string   "email",               :limit => 40
    t.string   "sigla_oper",          :limit => 8
    t.text     "note_opa"
    t.text     "frasi"
    t.text     "note_prev"
    t.text     "note_servizi"
    t.string   "regions",             :limit => 18
    t.integer  "cod_viagg"
    t.text     "note_coge"
    t.integer  "cod_age_2"
    t.text     "note_foglio"
    t.boolean  "show_pax",                                                         :default => true
    t.boolean  "round_total",                                                      :default => true
    t.text     "note_gen"
    t.text     "note_lqc"
    t.text     "note_lqnc"
    t.text     "note_hm"
    t.string   "actok"
    t.datetime "exptok"
    t.datetime "agency_reading_time"
    t.text     "note_riduzioni"
    t.boolean  "show_logo",                                                        :default => true
    t.date     "dt_stampa_conferma"
    t.integer  "st_agg_pax",                                                       :default => 0
    t.string   "nome_gruppo",         :limit => 40
  end

  add_index "mtour_tesprats", ["anagen_id"], :name => "index_mtour_tesprats_on_anagen_id"
  add_index "mtour_tesprats", ["codice_cliente"], :name => "index_mtour_tesprats_on_codice_cliente"
  add_index "mtour_tesprats", ["codice_pratica"], :name => "index_mtour_tesprats_on_codice_pratica"
  add_index "mtour_tesprats", ["gac_license_id"], :name => "index_mtour_tesprats_on_gac_license_id"

  create_table "my_pages", :force => true do |t|
    t.integer  "gac_application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shell_page",         :limit => 40
    t.string   "layout",             :limit => 80
    t.string   "landing_page",       :limit => 40
  end

  create_table "nodes", :force => true do |t|
    t.integer  "plant_id"
    t.integer  "device_id"
    t.string   "name",       :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "x"
    t.integer  "y"
  end

  add_index "nodes", ["device_id"], :name => "index_nodes_on_device_id"
  add_index "nodes", ["name"], :name => "index_nodes_on_name"
  add_index "nodes", ["plant_id"], :name => "index_nodes_on_plant_id"

  create_table "packs", :force => true do |t|
    t.integer  "codice_interno"
    t.string   "codice_kpl",       :limit => nil
    t.string   "codice_tmc",       :limit => nil
    t.float    "nl"
    t.float    "nw"
    t.string   "orient",           :limit => nil
    t.integer  "vmax"
    t.string   "picture",          :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "nh"
    t.string   "img_file_name",    :limit => nil
    t.string   "img_content_type", :limit => nil
    t.integer  "img_file_size"
    t.datetime "img_updated_at"
    t.string   "tipo_bs",          :limit => 1,   :default => "F"
    t.string   "tipo_kb",          :limit => 1
    t.integer  "user_c"
  end

  add_index "packs", ["codice_interno"], :name => "index_packs_on_codice_interno"
  add_index "packs", ["tipo_kb"], :name => "index_packs_on_tipo_kb"

  create_table "paeses", :force => true do |t|
    t.string   "descriz",    :limit => 50, :null => false
    t.string   "tpeu",       :limit => 1,  :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "prepiva",    :limit => 2
    t.string   "codfis",     :limit => 4
  end

  add_index "paeses", ["descriz"], :name => "idx_paeses_on_descriz", :unique => true

  create_table "page_views", :force => true do |t|
    t.integer  "my_page_id"
    t.text     "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "layout",      :limit => 80
  end

  create_table "pallets", :force => true do |t|
    t.string   "desc",           :limit => 40
    t.integer  "codice_interno"
    t.integer  "nl"
    t.integer  "nw"
    t.integer  "nh"
    t.integer  "user_c"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pallets", ["codice_interno"], :name => "index_pallets_on_codice_interno"

  create_table "papers", :force => true do |t|
    t.integer  "codice_interno"
    t.float    "gram_carta"
    t.float    "diam_est"
    t.string   "paper_type",     :limit => nil
    t.string   "description",    :limit => nil
    t.float    "passo_perf"
    t.integer  "n_strappi"
    t.float    "diam_anima"
    t.float    "gram_anima"
    t.float    "qc_anima"
    t.float    "qc_lembo"
    t.float    "qc_finale"
    t.float    "qc_strati"
    t.float    "qc_stampa"
    t.float    "qc_arom"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "nr_veli"
    t.integer  "user_c"
  end

  add_index "papers", ["codice_interno"], :name => "index_papers_on_codice_interno"

  create_table "plants", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.string   "img_file_name",             :limit => nil
    t.string   "img_content_type",          :limit => nil
    t.integer  "img_file_size"
    t.datetime "img_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "schema_image_file_name",    :limit => nil
    t.string   "schema_image_content_type", :limit => nil
    t.integer  "schema_image_file_size"
    t.datetime "schema_image_updated_at"
    t.integer  "model_id"
    t.integer  "manufacturer_id"
    t.string   "manufacturer",              :limit => 80
    t.integer  "project_id"
    t.string   "project",                   :limit => 80
    t.string   "rif_model",                 :limit => 80
    t.string   "ser_num",                   :limit => 80
    t.integer  "customer_id"
    t.string   "customer",                  :limit => 80
    t.integer  "author_id"
    t.string   "picture_file_name",         :limit => nil
    t.string   "picture_content_type",      :limit => nil
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "creation_date"
    t.datetime "modification_date"
    t.integer  "minor_revision"
    t.integer  "major_revision"
    t.integer  "count_revision"
    t.date     "installation_date"
    t.integer  "location_id"
    t.string   "location",                  :limit => nil
    t.integer  "accessibility"
    t.integer  "prot_list_id"
    t.string   "permacode",                 :limit => 10
  end

  add_index "plants", ["model_id"], :name => "index_plants_on_model_id"
  add_index "plants", ["user_id"], :name => "index_plants_on_user_id"

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

  create_table "price_lists", :force => true do |t|
    t.string   "description", :limit => 80
    t.integer  "filter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prices", :force => true do |t|
    t.integer  "codice_interno"
    t.string   "price_type",     :limit => nil
    t.string   "description",    :limit => nil
    t.float    "value"
    t.string   "um",             :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_list_id"
    t.integer  "user_c"
    t.integer  "basic_unit_id"
    t.string   "desc_es",        :limit => 80
    t.string   "desc_en",        :limit => 80
    t.string   "desc_ja",        :limit => 80
    t.string   "desc_br",        :limit => 80
    t.string   "desc_de",        :limit => 80
    t.string   "desc_fr",        :limit => 80
  end

  add_index "prices", ["codice_interno"], :name => "index_prices_on_codice_interno"

  create_table "prod_plans", :force => true do |t|
    t.integer  "factory_id"
    t.float    "year_qty"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "code",          :limit => 16
    t.string   "description",   :limit => 80
    t.integer  "prod_plan_id"
    t.integer  "plant_id"
    t.integer  "dev_format_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trigger_role",                :default => 0
  end

  create_table "qras", :force => true do |t|
    t.text     "data"
    t.text     "result"
    t.text     "message"
    t.integer  "tot_prog"
    t.integer  "stat_prog"
    t.datetime "date_schedule"
    t.datetime "date_start"
    t.datetime "date_end"
    t.string   "command",       :limit => nil
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "qras", ["user_id"], :name => "index_qras_on_user_id"

  create_table "reports", :force => true do |t|
    t.string   "description",           :limit => nil
    t.integer  "user_id"
    t.string   "document_file_name",    :limit => nil
    t.string   "document_content_type", :limit => nil
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "n_folder",                             :default => 0
    t.integer  "n_state",                              :default => 0
    t.integer  "n_private",                            :default => 0
    t.integer  "n_group",                              :default => 0
    t.datetime "accessed_at"
  end

  add_index "reports", ["user_id"], :name => "index_reports_on_user_id"

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

  create_table "rights", :force => true do |t|
    t.string   "action",     :limit => nil
    t.string   "controller", :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state"
  end

  add_index "rights", ["controller"], :name => "index_rights_on_controller"

  create_table "rights_roles", :id => false, :force => true do |t|
    t.integer "right_id"
    t.integer "role_id"
  end

  add_index "rights_roles", ["right_id"], :name => "index_rights_roles_on_right_id"
  add_index "rights_roles", ["role_id"], :name => "index_rights_roles_on_role_id"

  create_table "roles", :force => true do |t|
    t.string   "name",       :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "rolls", :force => true do |t|
    t.string   "desc",           :limit => 40
    t.string   "tipo_kb",        :limit => 1
    t.integer  "codice_interno"
    t.integer  "lcut"
    t.integer  "user_c"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rolls", ["codice_interno"], :name => "index_rolls_on_codice_interno"

  create_table "routes", :force => true do |t|
    t.integer  "id_node_in"
    t.integer  "id_node_out"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "routes", ["id_node_in"], :name => "index_routes_on_id_node_in"
  add_index "routes", ["id_node_out"], :name => "index_routes_on_id_node_out"

  create_table "sacks", :force => true do |t|
    t.integer  "pack_id"
    t.integer  "codice_interno"
    t.string   "codice_kpl",       :limit => nil
    t.string   "codice_tmc",       :limit => nil
    t.float    "nl"
    t.float    "nw"
    t.float    "nh"
    t.string   "orient",           :limit => nil
    t.integer  "vmax"
    t.string   "picture",          :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "img_file_name",    :limit => nil
    t.string   "img_content_type", :limit => nil
    t.integer  "img_file_size"
    t.datetime "img_updated_at"
    t.string   "tipo_bc",          :limit => 1,   :default => "B"
    t.string   "tipo_kb",          :limit => 1
    t.string   "orient2",          :limit => 1
    t.integer  "user_c"
  end

  add_index "sacks", ["codice_interno"], :name => "index_sacks_on_codice_interno"
  add_index "sacks", ["pack_id"], :name => "index_sacks_on_pack_id"
  add_index "sacks", ["tipo_kb"], :name => "index_sacks_on_tipo_kb"

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

  create_table "subscription_items", :force => true do |t|
    t.integer  "subscription_id"
    t.integer  "user_id"
    t.date     "date_start"
    t.date     "date_end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.float    "fee"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "duration"
    t.integer  "max_users"
    t.string   "template_user_nick", :limit => nil
  end

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

  create_table "tickets", :force => true do |t|
    t.string   "title",                 :limit => 40
    t.text     "content"
    t.integer  "priority"
    t.integer  "state"
    t.text     "notes"
    t.date     "date_requested"
    t.date     "date_expected"
    t.date     "date_charged"
    t.date     "date_suspended"
    t.date     "date_completed"
    t.integer  "progress"
    t.integer  "applicant_id"
    t.integer  "developer_id"
    t.string   "document_file_name",    :limit => nil
    t.string   "document_content_type", :limit => nil
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "code"
    t.integer  "category"
  end

  add_index "tickets", ["applicant_id"], :name => "index_tickets_on_applicant_id"
  add_index "tickets", ["developer_id"], :name => "index_tickets_on_developer_id"
  add_index "tickets", ["state"], :name => "index_tickets_on_state"

  create_table "tracked_actions", :force => true do |t|
    t.string   "action",     :limit => nil
    t.string   "controller", :limit => nil
    t.integer  "max_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracking_monitors", :force => true do |t|
    t.string   "action",        :limit => nil
    t.string   "controller",    :limit => nil
    t.text     "params"
    t.integer  "user_id"
    t.datetime "checkin_time"
    t.datetime "checkout_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "session_id",    :limit => 40
    t.string   "ip",            :limit => 40
  end

  add_index "tracking_monitors", ["session_id"], :name => "index_tracking_monitors_on_session_id"
  add_index "tracking_monitors", ["user_id"], :name => "index_tracking_monitors_on_user_id"

  create_table "translations", :force => true do |t|
    t.integer  "language_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "translatable_id"
    t.string   "translatable_type", :limit => nil
    t.string   "type",              :limit => nil
  end

  create_table "typeformats", :force => true do |t|
    t.string   "description", :limit => 50
    t.string   "des_button",  :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_refs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "type_ref",                 :default => 0
    t.string   "desc",       :limit => 30
    t.string   "ref",        :limit => 80
    t.integer  "state",                    :default => 0
    t.integer  "mode",                     :default => 0
    t.integer  "click_cnt",                :default => 0
    t.datetime "last_click"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
