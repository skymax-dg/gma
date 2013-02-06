class ConfsController < ApplicationController
  before_filter :authenticate

  def index
    @title = "Elenco Configurazioni"
    flash_cnt(Conf.count) if params[:page].nil?
    @confs = Conf.paginate(:page => params[:page], :per_page => 10, :order => [:descriz])
    store_location
  end

  def show
    @title = "Mostra Dati configurazione"
    @conf = Conf.find(params[:id])
  end

  def new
    @title = "Nuova configurazione"
    @conf = Conf.new
    @causmags = Causmag.find(:all, :order => :descriz)
  end

  def edit
    @title = "Modifica Dati configurazione"
    @conf = Conf.find(params[:id])
  end

  def create
    @conf = Conf.new(params[:conf])
    @title = "Nuova configurazione"
    if @conf.save
      flash[:success] = "Dati configurazione inseriti con successo."
      redirect_to @conf, notice: 'Nuova configurazione creata.'
    else
      @title = "Inserisci Dati configurazione"
      render action: "new"
    end
  end

  def update
    @conf = Conf.find(params[:id])

    if @conf.update_attributes(params[:conf])
      redirect_to @conf, notice: 'Configurazione aggiornata.'
    else
      @title = "Modifica Dati configurazione"
      render action: "edit"
    end
  end

  def destroy
    @conf = Conf.find(params[:id])
    begin
      @conf.destroy
      flash[:success] = "Cancellazione Eseguita"
    rescue
      flash[:alert] = $!.message
    end
    redirect_to confs_url
  end
end
