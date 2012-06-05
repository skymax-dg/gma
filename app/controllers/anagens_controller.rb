class AnagensController < ApplicationController
  def index
    @anagens = Anagen.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @anagen = Anagen.find(params[:id])
  end

  def new
    @anagen = Anagen.new
    @anagen.codice = Anagen.newcod
  end

  def edit
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
    if @anagen.save
      redirect_to @anagen, :notice => 'Anagrafica soggetti creata con successo.'
    else
      flash[:error] = "Il salvataggio dell'anagrafica non e' andato a buon fine"
      render :action => "new"
    end
  end

  def update
    @anagen = Anagen.find(params[:id])
    if @anagen.update_attributes(params[:anagen])
      redirect_to @anagen, :notice => 'Anagrafica soggetti aggiornata con successo.'
    else
      flash[:error] = "Il salvataggio dell'anagrafica non e' andato a buon fine"
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
