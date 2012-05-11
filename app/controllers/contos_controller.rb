class ContosController < ApplicationController
  def index
    @contos = Conto.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @conto = Conto.find(params[:id])
  end

  def new
    @conto = Conto.new
  end

  def edit
    @conto = Conto.find(params[:id])
  end

  def create
    @conto = Conto.new(params[:conto])
    if @conto.save
      redirect_to @conto, :notice => 'Conto was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    @conto = Conto.find(params[:id])
    if @conto.update_attributes(params[:conto])
      redirect_to @conto, :notice => 'Conto was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @conto = Conto.find(params[:id])
    @conto.destroy
    redirect_to contos_url
  end
end
