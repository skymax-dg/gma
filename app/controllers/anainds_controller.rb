class AnaindsController < ApplicationController
  def create
    @anagen = Anagen.find(params[:anaind][:anagen_id])
    @anaind = @anagen.anainds.build(params[:anaind])
    if @anaind.save
      flash[:success] = "AGGIUNTO Indirizzo anagrafico!"
      redirect_to @anagen
    else
      flash[:error] = "ERRORE !!! Salvatatggio indirizzo non riuscito"
      redirect_to @anagen
    end
  end

  def show
    @anaind = Anaind.find(params[:id])
  end

  def edit
    @anaind = Anaind.find(params[:id])
  end

  def update
    @anaind = Anaind.find(params[:id])
    if @anaind.update_attributes(params[:anaind])
      redirect_to @anaind, :notice => 'Indirizzo anagrafico modificato con successo.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @anaind = Anaind.find(params[:id])
    @anaind.destroy
redirect_to anainds_url
#redirect_to @anaind.anagen
  end
end
