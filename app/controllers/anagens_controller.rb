class AnagensController < ApplicationController
  def index
    @anagens = Anagen.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @anagen = Anagen.find(params[:id])
  end

  def new
    @anagen = Anagen.new
  end

  def edit
    @anagen = Anagen.find(params[:id])
  end

  def create
    @anagen = Anagen.new(params[:anagen])
    if @anagen.save
      redirect_to @anagen, :notice => 'Anagrafica soggetti creata con successo.'
    else
      render :action => "new"
    end
  end

  def update
    @anagen = Anagen.find(params[:id])
    if @anagen.update_attributes(params[:anagen])
      redirect_to @anagen, :notice => 'Anagrafica soggetti aggiornata con successo.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @anagen = Anagen.find(params[:id])
    begin
      @anagen.destroy
    rescue
      flash[:notice] = $!.message
    end
    redirect_to anagens_url
  end
end
