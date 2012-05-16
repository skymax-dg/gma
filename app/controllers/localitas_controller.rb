class LocalitasController < ApplicationController
  def index
    @localitas = Localita.all
  end

  def show
    @localita = Localita.find(params[:id])
  end

  def new
    @localita = Localita.new
  end

  def edit
    @localita = Localita.find(params[:id])
  end

  def create
    @localita = Localita.new(params[:localita])
    if @localita.save
      redirect_to @localita, :notice => 'Localita was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    @localita = Localita.find(params[:id])
    if @localita.update_attributes(params[:localita])
      redirect_to @localita, :notice => 'Localita was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @localita = Localita.find(params[:id])
    @localita.destroy
    redirect_to localitas_url
  end
end
