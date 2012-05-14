class AnaindsController < ApplicationController
#  def index
#    @anainds = Anaind.all
#  end

#  def new
#    @anaind = Anaind.new
#  end

  def create
    @anagen = Anagen.find(params[:anaind][:anagen_id])
#    newprg = @tesdoc.rigdocs.last.prgrig + 1  
    @anaind = @anagen.anainds.build(params[:anaind])
#    @rigdoc.prgrig = newprg
    if @anaind.save
      flash[:success] = "AGGIUNTO Indirizzo anagrafico!"
      redirect_to @anagen
    else
      flash[:error] = "ERRORE !!! Salvatatggio indirizzo non riuscito"
      redirect_to @anagen
    end
#    @anaind = Anaind.new(params[:anaind])
#    if @anaind.save
#      redirect_to @anaind, :notice => 'Anaind was successfully created.'
#    else
#      render :action => "new"
#    end
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
