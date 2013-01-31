class String
  def to_file_name
    self.downcase.gsub(/\.|\'|,|!|\s/,'_')
  end
  
  def is_date?
    temp = self.gsub(/[-,\/]/, '')
    ['%d%m%Y','%d%m%y'].each do |formato|
      begin
        Date.strptime(temp,formato)
        return true
      rescue
        #
      end
    end
    
    false
  end
  
  def is_numeric?
    Float(self) != nil rescue false
  end

  def to_my_date
    temp = self.gsub(/[-,\/]/, '')
    ['%d%m%Y','%d%m%y'].each do |formato|
      begin
        return Date.strptime(temp,formato)       
      rescue
        #
      end
    end
    nil
  end
end