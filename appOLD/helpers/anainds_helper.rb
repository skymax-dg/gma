module AnaindsHelper
  def compat_mag(flmg, nrmag)
    return false if (flmg == "S" and nrmag == 0) or
                    (flmg == "N" and nrmag > 0)
    return true
  end
end
