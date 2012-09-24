class PaesesController < ApplicationController

  before_filter :authenticate
  before_filter :force_fieldcase, :only => [:create, :update]

  def index
    @title = "Elenco Stati/Nazioni"
    flash_cnt(Paese.count) if params[:page].nil?
    @paeses = Paese.paginate(:page => params[:page], :per_page => 10, :order => [:descriz])
store_location
  end

  def show
    @title = "Mostra Stato/Nazione"
    @paese = Paese.find(params[:id])
  end

  def new
    @title = "Nuovo Stato/Nazione"
    @paese = Paese.new
    @paese.descriz = params[:descriz] unless params[:descriz].nil?
  end

  def edit
    @title = "Modifica Stato/Nazione"
    @paese = Paese.find(params[:id])
  end

  def create
    @paese = Paese.new(params[:paese])
    if @paese.save
      flash[:success] = "Nazione/Stato inserito con successo."
      redirect_to @paese
    else
      @title = "Nuovo Stato/Nazione"
#      flash.now[:alert] = "Il salvataggio del paese non e' andato a buon fine"
      render :action => "new"
    end
  end

  def update
    @paese = Paese.find(params[:id])
    if @paese.update_attributes(params[:paese])
      flash[:success] = "Nazione/Stato aggiornato con successo."
      redirect_to @paese
    else
      @title = "Modifica Stato/Nazione"
#      flash.now[:alert] = "Il salvataggio del paese non e' andato a buon fine"
      render :action => "edit"
    end
  end

  def destroy
    @paese = Paese.find(params[:id])

    begin
      @paese.destroy
      flash[:success] = "Cancellazione Eseguita"
    rescue
      flash[:alert] = $!.message
    end
redirect_back_or @paese
  end

  private
    def force_fieldcase
      set_fieldcase(:paese, [:prepiva,:codfis], [])
    end
end
