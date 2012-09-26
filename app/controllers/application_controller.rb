class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include TesdocsHelper

  def set_fieldcase(model, fld_upcase = [], fld_dwcase = [])
    fld_upcase.each {|v| params[model][v]=params[model][v].upcase if params[model][v]}
    fld_dwcase.each {|v| params[model][v]=params[model][v].downcase if params[model][v]}
  end

  def flash_cnt(nrrecord)
    nrrecord == 0 ? flash.now[:alert] = "Ricerca negativa nessun risultato trovato!"
                  : flash.now[:success] = "La ricerca ha prodotto #{nrrecord} risultati"
  end
end
