class KeyWord < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :desc, :parent_id, :keyword_type, :type, :n_order

  belongs_to :parent, class_name: "KeyWord" , foreign_key: "parent_id"
  has_many :childs, class_name: "KeyWord" , foreign_key: "parent_id"
  has_many :key_word_rels, dependent: :destroy

  before_create :assign_type
  after_create :set_n_order

  default_scope order("n_order ASC")

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

  def self.sort_by_din(ds)
    ds.sort_by { |x| x.get_dinasty }
  end

  def set_n_order
    x = self.parent && self.parent.childs.last
    x = x && x.n_order + 1 || 1
    self.n_order = x
    self.save
  end

  # 1 -> UP
  # 2 -> DOWN
  def change_n_order(mode)
    return false unless self.parent

    if mode == 1
      if self.n_order != 1
        kw = self.parent.childs.where(n_order: self.n_order-1).first
        if kw
          kw.n_order += 1
          self.n_order -= 1
          kw.save
          self.save
        end
      end

    elsif mode == 2
    kw = self.parent.childs.where(n_order: self.n_order+1).last
    puts "---- kw: #{kw.n_order} vs self: #{self.n_order}"
    if kw && self.n_order < kw.n_order
      kw.n_order -= 1
      self.n_order += 1
      kw.save
      self.save
      end
    end
  end

  private
    def assign_type
      if !self.type && self.parent
        self.type = self.parent.type
      end
    end

end
