class LocalitasController < ApplicationController
  before_filter :authenticate
  before_filter :force_fieldcase, :only => [:create, :update]

  def filter
    @tpfilter  = params[:tpfilter]
    @desfilter = params[:desfilter].strip
    @localitas, nrrecord = Localita.filter(@tpfilter, @desfilter, params[:page])
    flash_cnt(nrrecord) if params[:page].nil?
    store_location
    render "index"
  end

  def index
    store_location
    @title = "Elenco Citta'"
  end

  def show
    @title = "Mostra Citta'"
    @localita = Localita.find(params[:id])
  end

  def new
    @title = "Nuova Citta'"
    @localita = Localita.new
  end

  def edit
    @title = "Modifica Citta'"
    @localita = Localita.find(params[:id])
  end

  def create
    @localita = Localita.new(params[:localita])
    if @localita.save
      flash[:success] = "Localita' inserita con successo."
      redirect_to @localita
    else
      @title = "Nuova Citta'"
#      flash.now[:alert] = "Il salvataggio della localita' non e' andato a buon fine"
      render :action => "new"
    end
  end

  def update
    @localita = Localita.find(params[:id])
    if @localita.update_attributes(params[:localita])
      flash[:success] = "Localita' aggiornata con successo."
      redirect_to @localita
    else
      @title = "Modifica Citta'"
#      flash.now[:alert] = "Il salvataggio della localita' non e' andato a buon fine"
      render :action => "edit"
    end
  end

  def destroy
    @localita = Localita.find(params[:id])
    begin
      @localita.destroy
      flash[:success] = "Cancellazione Eseguita"
    rescue
      flash[:alert] = $!.message
    end
    redirect_back_or @localita
  end

  private
    def force_fieldcase
      set_fieldcase(:localita, [:prov, :cap, :codfis], [])
    end
end
