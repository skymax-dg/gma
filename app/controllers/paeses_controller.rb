class PaesesController < ApplicationController
  def index
    @paeses = Paese.all
  end

  def show
    @paese = Paese.find(params[:id])
  end

  def new
    @paese = Paese.new
  end

  def edit
    @paese = Paese.find(params[:id])
  end

  def create
    @paese = Paese.new(params[:paese])
    if @paese.save
      redirect_to @paese, :notice => 'Nasione/Stato inserito con successo.' 
    else
      render :action => "new"
    end
  end

  def update
    @paese = Paese.find(params[:id])
    if @paese.update_attributes(params[:paese])
      redirect_to @paese, :notice => 'Nasione/Stato aggiornato con successo.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @paese = Paese.find(params[:id])
    @paese.destroy
    redirect_to paeses_url
  end
end
