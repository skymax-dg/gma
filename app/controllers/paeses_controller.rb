class PaesesController < ApplicationController
  def index
    @paeses = Paese.paginate(:page => params[:page], :per_page => 10, :order => [:descriz])
  end

  def show
    @paese = Paese.find(params[:id])
  end

  def new
    @paese = Paese.new
    @paese.descriz = params[:descriz] unless params[:descriz].nil?
  end

  def edit
    @paese = Paese.find(params[:id])
  end

  def create
    @paese = Paese.new(params[:paese])
    if @paese.save
      redirect_to @paese, :notice => 'Nazione/Stato inserito con successo.' 
    else
      flash[:error] = "Il salvataggio del paese non e' andato a buon fine"
      render :action => "new"
    end
  end

  def update
    @paese = Paese.find(params[:id])
    if @paese.update_attributes(params[:paese])
      redirect_to @paese, :notice => 'Nazione/Stato aggiornato con successo.'
    else
      flash[:error] = "Il salvataggio del paese non e' andato a buon fine"
      render :action => "edit"
    end
  end

  def destroy
    @paese = Paese.find(params[:id])

    begin
      @paese.destroy
      flash[:notice] = "Cancellazione Eseguita"
    rescue
      flash[:error] = $!.message
    end
    redirect_to paeses_url
  end
end
