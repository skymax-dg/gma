class ContosController < ApplicationController
before_filter :authenticate
  def filter
    @tpfilter  = params[:tpfilter]
    @desfilter = params[:desfilter].strip
    @contos = Conto.filter(@tpfilter, @desfilter, current_user.azienda, current_annoese, params[:page])
    render "index"
  end

  def index
    @title = "Elenco Conti"
    #@contos = Conto.azdanno(current_user.azienda, current_annoese).paginate(:page => params[:page],
    #                                                                        :per_page => 10,
    #                                                                        :order => [:codice])
  end

  def anagen_exit
    @descriz = Anagen.find(params[:conto][:anagen_id]).denomin unless params[:conto][:anagen_id].empty? 
    respond_to do |format|
      format.js
    end
  end

  def show
    @title = "Mostra Conto"
    @conto = Conto.find(params[:id])
  end

  def new
    @title = "Nuovo Conto"
    @conto = Conto.new
    @conto.azienda = current_user.azienda
    @conto.annoese = current_annoese
  end

  def edit
    @title = "Modifica Conto"
    @conto = Conto.find(params[:id])
  end

  def create
    @conto = Conto.new(params[:conto])
    if not compat_tipoconto(@conto.tipoconto, @conto.anagen_id.nil?)
      flash.alert = "Per la tipologia #{Conto::TIPOCONTO["C"]}/#{Conto::TIPOCONTO["F"]} " +
                    "e' obbligatorio specificare una anagrafica soggetto"
      render :action => "new"
    else
      if @conto.save
        redirect_to @conto, :notice => 'Piano dei conti inserita con successo.'
      else
        flash[:error] = "Il salvataggio del piano dei conti non e' andato a buon fine"
        render :action => "new"
      end
    end
  end

  def update
    @conto = Conto.find(params[:id])
    if not compat_tipoconto(params[:conto][:tipoconto], params[:conto][:anagen_id].nil?)
      flash.alert = "Per la tipologia #{Conto::TIPOCONTO["C"]}/#{Conto::TIPOCONTO["F"]} " +
                    "e' obbligatorio specificare una anagrafica soggetto"
    else
      if @conto.update_attributes(params[:conto])
        redirect_to @conto, :notice => 'Piano dei conti aggiornato con successo.'
      else
        flash[:error] = "Il salvataggio del piano dei conti non e' andato a buon fine"
        render :action => "edit"
      end
    end
  end

  def destroy
    @conto = Conto.find(params[:id])
    begin
      @conto.destroy
      flash[:notice] = "Cancellazione Eseguita"
    rescue
      flash[:error] = $!.message
    end
    redirect_to contos_url
  end
end
