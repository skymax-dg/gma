class IvasController < ApplicationController
  def index
    @ivas = Iva.all
  end

  def show
    @iva = Iva.find(params[:id])
  end

  def new
    @iva = Iva.new
  end

  def edit
    @iva = Iva.find(params[:id])
  end

  def create
    @iva = Iva.new(params[:iva])
    @iva.aliq = 0 if @iva.flese == "S" # Se si tratta di esenzione l'aliquota viene impostata a 0

    if @iva.save
      redirect_to @iva, notice => 'Iva was successfully created.'
    else
      render action => "new"
    end
  end

  def update
    @iva = Iva.find(params[:id])
    @iva.aliq = 0 if @iva.flese == "S" # Se si tratta di esenzione l'aliquota viene impostata a 0

    if @iva.update_attributes(params[:iva])
      redirect_to @iva, notice => 'Iva was successfully updated.'
    else
      render action => "edit"
    end
  end

  def destroy
    @iva = Iva.find(params[:id])
    @iva.destroy
    redirect_to ivas_url
  end
end
