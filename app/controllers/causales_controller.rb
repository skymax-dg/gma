class CausalesController < ApplicationController
before_filter :authenticate
  def index
    @title = "Elenco Causali contabili"
    flash_cnt(Causale.count) if params[:page].nil?
    @causales = Causale.azienda(current_user.azienda).paginate(:page => params[:page], 
                                                               :per_page => 10,
                                                               :order => [:descriz])
store_location
  end

  def show
    @title = "Mostra Causale contabile"
    @causale = Causale.find(params[:id])
  end

  def new
    @title = "Nuova Causale contabile"
    @causale = Causale.new
    @causale.azienda = current_user.azienda
  end

  def edit
    @title = "Modifica Causale contabile"
    @causale = Causale.find(params[:id])
  end

  def create
    @causale = Causale.new(params[:causale])
    if @causale.save
      flash[:success] = 'Causale contabile inserita con successo.'
      redirect_to @causale
    else
      @title = "Nuova Causale contabile"
#      flash.now[:alert] = "Il salvataggio della causale non e' andato a buon fine"
      render :action => "new"
    end
  end

  def update
    @causale = Causale.find(params[:id])
    if @causale.update_attributes(params[:causale])
      flash[:success] = 'Causale contabile aggiornata con successo.'
      redirect_to @causale
    else
      @title = "Modifica Causale contabile"
#      flash.now[:alert] = "Il salvataggio della causale non e' andato a buon fine"
      render :action => "edit"
    end
  end

  def destroy
    @causale = Causale.find(params[:id])
    begin
      @causale.destroy
      flash[:success] = "Cancellazione Eseguita"
    rescue
      flash[:alert] = $!.message
    end
redirect_back_or @causale
  end
end
