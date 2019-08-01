class KeyWord < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :desc, :parent_id

  belongs_to :parent, class_name: "KeyWord" , foreign_key: "parent_id"
  has_many :childs, class_name: "KeyWord" , foreign_key: "parent_id"

  def get_dinasty
    if self.parent
      msg = "/ %s "%[self.desc]
      msg = self.parent.get_dinasty+msg
      msg
    else
      ""
    end
  end
end
