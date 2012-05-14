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

  def addind
    @anaind = Anagen.find(params[:id]).anainds.build # La Build valorizza automaticamente il campo anaind.anagen_id 
  end

  def edit
    @anagen = Anagen.find(params[:id])
  end

  def create
    @anagen = Anagen.new(params[:anagen])
    if @anagen.save
      redirect_to @anagen, :notice => 'Anagen was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    @anagen = Anagen.find(params[:id])
    if @anagen.update_attributes(params[:anagen])
      redirect_to @anagen, :notice => 'Anagen was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @anagen = Anagen.find(params[:id])
    @anagen.destroy
    redirect_to anagens_url
  end
end
