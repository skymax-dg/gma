class ContosController < ApplicationController
before_filter :authenticate
  def filter
    @tpfilter  = params[:tpfilter]
    @desfilter = params[:desfilter].strip
    @contos, nrrecord = Conto.filter(@tpfilter, @desfilter, current_user.azienda, current_annoese, params[:page])
    flash_cnt(nrrecord) if params[:page].nil?
store_location
    render "index"
  end

  def index
    @title = "Elenco Conti"
store_location
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
    @conto.codice = Conto.new_codice(@conto.annoese, @conto.azienda)
  end

  def edit
    @title = "Modifica Conto"
    @conto = Conto.find(params[:id])
  end

  def create
    @conto = Conto.new(params[:conto])
    if (@conto.tipoconto=="C"||@conto.tipoconto=="F")&&@conto.anagen_id.nil?
      @title = "Nuovo Conto"
      flash.now[:alert] = "Per un conto #{Conto::TIPOCONTO["C"]}/#{Conto::TIPOCONTO["F"]} 
                           e' obbligatorio specificare una anagrafica soggetto"
      render :action => "new"
    else
      if @conto.save
        flash[:success] = 'Piano dei conti inserito con successo.'
        redirect_to @conto
      else
        @title = "Nuovo Conto"
#        flash.now[:alert] = "Il salvataggio del piano dei conti non e' andato a buon fine"
        render :action => "new"
      end
    end
  end

  def update
    @conto = Conto.find(params[:id])
    @conto.tipoconto=params[:conto][:tipoconto]
    @conto.anagen_id=params[:conto][:anagen_id]
    if (@conto.tipoconto=="C"||@conto.tipoconto=="F")&&@conto.anagen_id.nil?
      @title = "Modifica Conto"
      flash.now[:alert] = "Per un conto #{Conto::TIPOCONTO["C"]}/#{Conto::TIPOCONTO["F"]} 
                           e' obbligatorio specificare una anagrafica soggetto"
      render :action => "edit"
    else
      if @conto.update_attributes(params[:conto])
        flash[:success] = "Piano dei conti aggiornato con successo."
        redirect_to @conto
      else
        @title = "Modifica Conto"
#        flash.now[:alert] = "Il salvataggio del piano dei conti non e' andato a buon fine"
        render :action => "edit"
      end
    end
  end

  def destroy
    @conto = Conto.find(params[:id])
    begin
      @conto.destroy
      flash[:success] = "Cancellazione Eseguita"
    rescue
      flash[:alert] = $!.message
    end
redirect_back_or @conto
  end
end
