class AnaindsController < ApplicationController
  def create
    @anagen = Anagen.find(params[:anaind][:anagen_id])
    @anaind = @anagen.anainds.build(params[:anaind])
    if @anaind.save
      redirect_to @anagen, :notice => 'Indirizzo anagrafico aggiunto con successo.'
    else
      render :action => :new
    end
  end

  def new
    @anaind = Anagen.find(params[:id]).anainds.build # La Build valorizza automaticamente il campo anaind.anagen_id
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
      render :action => :edit
    end
  end

  def destroy
    @anaind = Anaind.find(params[:id])
    @anaind.destroy
    redirect_to @anaind.anagen
  end
end
