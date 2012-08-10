class LocalitasController < ApplicationController
before_filter :authenticate
  def index
    @title = "Elenco Citta'"
    @localitas = Localita.paginate(:page => params[:page], :per_page => 15, :order => [:descriz])
#    @des = ""
#    @localitas = Localita.where("descriz like '%#{@des}%'").paginate(:page => params[:page], :per_page => 10, :order => [:descriz])
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
      redirect_to @localita, :notice => 'Localita'' inserita con successo.'
    else
      flash[:error] = "Il salvataggio della localita' non e' andato a buon fine"
      render :action => "new"
    end
  end

  def update
    @localita = Localita.find(params[:id])
    if @localita.update_attributes(params[:localita])
      redirect_to @localita, :notice => 'Localita'' aggiornata con successo.'
    else
      flash[:error] = "Il salvataggio della localita' non e' andato a buon fine"
      render :action => "edit"
    end
  end

  def destroy
    @localita = Localita.find(params[:id])
    begin
      @localita.destroy
      flash[:notice] = "Cancellazione Eseguita"
    rescue
      flash[:error] = $!.message
    end
    redirect_to localitas_url
  end
end
