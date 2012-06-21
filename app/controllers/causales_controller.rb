class CausalesController < ApplicationController
  def index
    @causales = Causale.azienda(current_user.azienda).paginate(:page => params[:page], 
                                                               :per_page => 10,
                                                               :order => [:descriz])
  end

  def show
    @causale = Causale.find(params[:id])
  end

  def new
    @causale = Causale.new
    @causale.azienda = current_user.azienda
  end

  def edit
    @causale = Causale.find(params[:id])
  end

  def create
    @causale = Causale.new(params[:causale])
    if @causale.save
      redirect_to @causale, :notice => 'Causale contabile inserita con successo.'
    else
      flash[:error] = "Il salvataggio della causale non e' andato a buon fine"
      render :action => "new"
    end
  end

  def update
    @causale = Causale.find(params[:id])
    if @causale.update_attributes(params[:causale])
      redirect_to @causale, :notice => 'Causale contabile aggiornata con successo.'
    else
      flash[:error] = "Il salvataggio della causale non e' andato a buon fine"
      render :action => "edit"
    end
  end

  def destroy
    @causale = Causale.find(params[:id])
    begin
      @causale.destroy
      flash[:notice] = "Cancellazione Eseguita"
    rescue
      flash[:error] = $!.message
    end
    redirect_to causales_url
  end
end
