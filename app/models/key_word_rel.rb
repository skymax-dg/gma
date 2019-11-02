class KeyWordRel < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :key_word, :desc, :key_wordable

  belongs_to :key_wordable, polymorphic: true
  belongs_to :key_word

  validates :key_word_id, :uniqueness => {scope: [:key_wordable_id, :key_wordable_type]}

end
