class KeyWordArticle < KeyWord
  # attr_accessible :title, :body
  def self.ecomm_root
    root = KeyWordArticle.where(desc: "Categorie").first
    self.map_json_array(root)
  end

  def self.map_json_array(a)
    ris = []
    a.childs.each do |x|
      ris << self.map_json_data(x)
      x.childs.each { |y| ris << self.map_json_array(y) }
    end
    [self.map_json_data(a),ris].flatten
  end

  def self.map_json_data(x)
    st = Struct.new(:id, :desc, :parent_id)
    st.new(x.id, x.desc, x.parent_id)
  end
end
