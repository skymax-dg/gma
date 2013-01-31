module Cfpi
  def self.data_by_cf(cf)
    if cf&&cf.length == 16
      y4=year_by_cf(cf)
      m2=month_by_cf(cf)
      g2=day_by_cf(cf)
      Date.strptime("{ #{y4}, #{m2}, #{g2} }", "{ %Y, %m, %d }") if y4&&m2&&g2
    end
  end

  def self.locnas_by_cf(cf)
    if cf[11,4]&&cf[11,4].match(/([A-Z][0-9]{3})/)
      cf[11,4].match(/([A-Z][0-9]{3})/)
    end
  end

  def self.checksum_cf(cf)
    if cf&&cf.length == 16
      t={
      "0"=>{true=>0,false=>1},   "1"=>{true=>1,false=>0},   "2"=>{true=>2,false=>5},   "3"=>{true=>3,false=>7},
      "4"=>{true=>4,false=>9},   "5"=>{true=>5,false=>13},  "6"=>{true=>6,false=>15},  "7"=>{true=>7,false=>17},
      "8"=>{true=>8,false=>19},  "9"=>{true=>9,false=>21},  "A"=>{true=>0,false=>1},   "B"=>{true=>1,false=>0},
      "C"=>{true=>2,false=>5},   "D"=>{true=>3,false=>7},   "E"=>{true=>4,false=>9},   "F"=>{true=>5,false=>13},
      "G"=>{true=>6,false=>15},  "H"=>{true=>7,false=>17},  "I"=>{true=>8,false=>19},  "J"=>{true=>9,false=>21},
      "K"=>{true=>10,false=>2},  "L"=>{true=>11,false=>4},  "M"=>{true=>12,false=>18}, "N"=>{true=>13,false=>20},
      "O"=>{true=>14,false=>11}, "P"=>{true=>15,false=>3},  "Q"=>{true=>16,false=>6},  "R"=>{true=>17,false=>8},
      "S"=>{true=>18,false=>12}, "T"=>{true=>19,false=>14}, "U"=>{true=>20,false=>16}, "V"=>{true=>21,false=>10},
      "W"=>{true=>22,false=>22}, "X"=>{true=>23,false=>25}, "Y"=>{true=>24,false=>24}, "Z"=>{true=>25,false=>23}
        }
      cnt=0
      cf[0,15].split("").each_with_index {|c,i| cnt+=t["#{c}"][i.odd?] }
      ((cnt%26)+65).chr==cf[15,1]
    end
  end

  def self.checksum_pi(pi)
    if pi&&pi.length == 11
      x=0 && y=0 && z=0
      pi[0,10].split("").each_with_index {|c,i| i.odd? ? (y+=2*c.to_i ; z+=1 if c.to_i>=5) : (x+=c.to_i)}
      (10-((x+y+z)%10))%10==pi[10,1].to_i
    end
  end

  def self.year_by_cf(cf)
    if cf[6,2]&&cf[6,2].is_numeric?
    # Visto che posso considerare solo un range di 100 anni do per scontato
    # che le anagrafiche siano tutte maggiorenni e quindi l'anno di nascita
    # sarà sempre compresso fra: (l'anno attuale - 18) e i 100 anni precedenti
      maxyear=Date.today.year-17 # 2013-17=1996
      y4=cf[6,2].to_i+(maxyear.to_s[0,2].to_i*100) # 90+(19*100) = 90+1900 = 1990
      y4=y4-100 if y4 > maxyear #.to_s[2,2].to_i="95"
      y4
    end
  end

  def self.month_by_cf(cf)
    if cf[8,1]
      mm=(["A", "B", "C", "D", "E", "H", "L", "M", "P", "R", "S", "T"].index(cf[8,1].upcase))
      mm ? mm+1 : nil
    end
  end

  def self.day_by_cf(cf)
    if cf[9,2]&&cf[9,2].is_numeric?
      dd=cf[9,2].to_i
      dd>40 ? dd-40 : dd
    end
  end

  def self.sex_by_cf(cf)
    if cf[9,2]&&cf[9,2].is_numeric?
      cf[9,2].to_i>40 ? "F" : "M"
    end
  end

end