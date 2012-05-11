class MagsController < ApplicationController
  def index
    @mags = Mag.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @mag = Mag.find(params[:id])
  end

  def new
    @mag = Mag.new
  end

  def edit
    @mag = Mag.find(params[:id])
  end

  def create
    @mag = Mag.new(params[:mag])
    if @mag.save
      redirect_to @mag, :notice => 'Mag was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    @mag = Mag.find(params[:id])
    if @mag.update_attributes(params[:mag])
      redirect_to @mag, :notice => 'Mag was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @mag = Mag.find(params[:id])
    @mag.destroy
    redirect_to mags_url
  end
end
