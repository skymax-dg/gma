class KeyWord < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :desc, :parent_id, :keyword_type

  belongs_to :parent, class_name: "KeyWord" , foreign_key: "parent_id"
  has_many :childs, class_name: "KeyWord" , foreign_key: "parent_id"
  has_many :key_word_rels

  def get_dinasty
    if self.parent
      msg = "/ %s "%[self.desc]
      msg = self.parent.get_dinasty+msg
      msg
    else
      ""
    end
  end

  def connect_item(ot_cls, ot_id)
    other    = ot_cls.find(ot_id)

    self.key_word_rels << KeyWordRel.create(key_wordable: other)
  end

  def remove_item(kwr_id)
    tmp = self.key_word_rels.find(kwr_id)
    tmp.destroy
  end

  def leaf?
    self.childs.count == 0
  end
end
