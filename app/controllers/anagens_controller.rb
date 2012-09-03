class AnagensController < ApplicationController
before_filter :authenticate
  def filter
    @title = "Elenco Soggetti/Societa'"
    @tpfilter  = params[:tpfilter]
    @desfilter = params[:desfilter].strip
    @anagens = Anagen.filter(@tpfilter, @desfilter, params[:page])
    render "index"
  end

  def index
    @title = "Elenco Soggetti/Societa'"
    #@anagens = Anagen.paginate(:page => params[:page], :per_page => 10, :order => [:denomin])
  end

  def show
    @title = "Mostra Soggetto/Societa'"
    @anagen = Anagen.find(params[:id])
  end

  def new
    @title = "Nuovo Soggetto/Societa'"
    @anagen = Anagen.new
    @anagen.codice = Anagen.newcod
  end

  def edit
    @title = "Modifica Soggetto/Societa'"
    @anagen = Anagen.find(params[:id])
  end

  def chg_tipo
    @anagen = Anagen.new
    @anagen.tipo = params[:anagen][:tipo]
    respond_to do |format|
      format.js
    end
  end

  def create
    @anagen = Anagen.new(params[:anagen])

    if Anagen.find_by_codice(params[:anagen][:codice])
      error = "Codice"
    elsif Anagen.find_by_denomin(params[:anagen][:denomin])
      error = "Ragione sociale"
    elsif params[:anagen][:pariva].strip.length > 0 && Anagen.find_by_pariva(params[:anagen][:pariva])
      error = "Partita Iva"
    elsif params[:anagen][:codfis].strip.length > 0 && Anagen.find_by_codfis(params[:anagen][:codfis])
      error = "Partita Iva"
    else  
      error = nil
    end

    if error.nil?
      if @anagen.save
        redirect_to @anagen, :notice => 'Anagrafica soggetti creata con successo.'
      else
        @title = "Nuovo Soggetto/Societa'"
        flash[:error] = "Il salvataggio dell'anagrafica non e' andato a buon fine"
        render :action => "new"
      end
    else
      @title = "Nuovo Soggetto/Societa'"
      flash[:error] = "Salvataggio fallito: Esiste un'anagrafica con uguale #{error}"
      render :action => "new"
    end
  end

  def update
    @anagen = Anagen.find(params[:id])

#if Anagen.find_by_codice(params[:anagen][:codice])
#  error = "Codice"
#elsif Anagen.find_by_denomin(params[:anagen][:denomin])
#  error = "Ragione sociale"
#elsif params[:anagen][:pariva].strip.length > 0 && Anagen.find_by_pariva(params[:anagen][:pariva])
#  error = "Partita Iva"
#elsif params[:anagen][:codfis].strip.length > 0 && Anagen.find_by_codfis(params[:anagen][:codfis])
#  error = "Partita Iva"
#else  
#  error = nil
#end

    if error.nil?
      if @anagen.update_attributes(params[:anagen])
        redirect_to @anagen, :notice => 'Anagrafica soggetti aggiornata con successo.'
      else
        @title = "Modifica Soggetto/Societa'"
        flash[:error] = "Il salvataggio dell'anagrafica non e' andato a buon fine"
        render :action => "edit"
      end
    else
      @title = "Modifica Soggetto/Societa'"
      flash[:error] = "Salvataggio fallito: Esiste un'anagrafica con uguale #{error}"
      render :action => "edit"
    end
  end

  def destroy
    @anagen = Anagen.find(params[:id])
    begin
      @anagen.destroy
      flash[:notice] = "Cancellazione Eseguita"
    rescue
      flash[:error] = $!.message
    end
    redirect_to anagens_url
  end
end
