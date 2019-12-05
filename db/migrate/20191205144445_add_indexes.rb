class AddIndexes < ActiveRecord::Migration
  def changes
    change_column :agentes,         :anagen_id,          :integer, index: true
    change_column :anag_socials,    :anagen_id,          :integer, index: true
    change_column :anagen_articles, :anagen_id,          :integer, index: true
    change_column :anagen_articles, :article_id,         :integer, index: true
    change_column :anagens,         :luogonas_id,        :integer, index: true
    change_column :anagens,         :primary_address_id, :integer, index: true
    change_column :anagens,         :paese_nas_id,       :integer, index: true
    change_column :anainds,         :localita_id,        :integer, index: true
    change_column :causales,        :azienda,            :integer, index: true
    change_column :caus_mags,       :causale_id,         :integer, index: true
    change_column :confs,           :codice,             :integer, index: true
    change_column :contos,          :anagen_id,          :integer, index: true
    change_column :coupons,         :anagen_id,          :integer, index: true
    change_column :event_states,    :anagen_id,          :integer, index: true
    change_column :event_states,    :event_id,           :integer, index: true
    change_column :event_states,    :mode,               :integer, index: true
    change_column :events,          :article_id,         :integer, index: true
    change_column :events,          :site_anagen_id,     :integer, index: true
    change_column :events,          :mode,               :integer, index: true
    change_column :ivas,            :codice,             :integer, index: true
    change_column :key_word_rels,   :key_word_id,        :integer, index: true
    change_column :key_word_rels,   :key_wordable_type,  :integer, index: true
    change_column :key_word_rels,   :key_wordable_id,    :integer, index: true
    change_column :key_word_rels,   :key_word_type,      :integer, index: true
    change_column :key_words,       :parent_id,          :integer, index: true
    change_column :key_words,       :keyword_type,       :integer, index: true
    change_column :paeses,          :prepiva,            :string,  index: true, limit: 2
    change_column :rigdocs,         :iva_id,             :integer, index: true
    change_column :spedizs,         :anaind_id,          :integer, index: true
    change_column :tesdocs,         :azienda,            :integer, index: true
    change_column :tesdocs,         :iva_id,             :integer, index: true
    change_column :tesdocs,         :agente_id,          :integer, index: true
    change_column :users,           :anagen_id,          :integer, index: true
    change_column :users,           :email,              :string,  index: true, limit: 60

    add_column    :anagen_articles, :state,              :integer, default: 0
  end
end
