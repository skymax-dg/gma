class ContosController < ApplicationController
  def index
    @contos = Conto.azdanno(StaticData::AZIENDA, StaticData::ANNOESE).paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @conto = Conto.find(params[:id])
  end

  def new
    @conto = Conto.new
    @conto.azienda = StaticData::AZIENDA
    @conto.annoese = StaticData::ANNOESE
  end

  def edit
    @conto = Conto.find(params[:id])
  end

  def create
    @conto = Conto.new(params[:conto])
    if (@conto.tipoconto = "C" or @conto.tipoconto = "F") and @conto.anagen_id.nil?
      flash.alert = "Per la tipologia " + Conto::TIPOCONTO["C"] + "/" + Conto::TIPOCONTO["F"] + " e' obbligatorio specificare una anagrafica soggetto"
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
    if @conto.update_attributes(params[:conto])
      redirect_to @conto, :notice => 'Piano dei conti aggiornato con successo.'
    else
      flash[:error] = "Il salvataggio del piano dei conti non e' andato a buon fine"
      render :action => "edit"
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
