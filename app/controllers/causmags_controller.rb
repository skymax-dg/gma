class CausmagsController < ApplicationController
  def index
    @causmags = Causmag.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @causmag = Causmag.find(params[:id])
  end

  def new
    @causmag = Causmag.new
  end

  def edit
    @causmag = Causmag.find(params[:id])
  end

  def create
    @causmag = Causmag.new(params[:causmag])
    if @causmag.save
      redirect_to @causmag, :notice => 'Causmag was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    @causmag = Causmag.find(params[:id])
    if @causmag.update_attributes(params[:causmag])
      redirect_to @causmag, :notice => 'Causmag was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @causmag = Causmag.find(params[:id])
    @causmag.destroy
    redirect_to causmags_url
  end
end
