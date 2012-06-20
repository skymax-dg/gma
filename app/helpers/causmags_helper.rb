module CausmagsHelper
  def compat_contabile(contabile, causale_id_nil)
    return false if (contabile == "S" and causale_id_nil) or
                    (contabile == "N" and !causale_id_nil)
    return true
  end
end
