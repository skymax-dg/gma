class IvasController < ApplicationController
  def index
    @title = "Elenco Tipi Iva/Esenzioni"
    @ivas = Iva.paginate(:page => params[:page], :per_page => 10, :order => [:codice])
  end

  def show
    @title = "Mostra Tipo Iva/Esenzione"
    @iva = Iva.find(params[:id])
  end

  def new
    @title = "Nuovo Tipo Iva/Esenzione"
    @iva = Iva.new
  end

  def edit
    @title = "Modifica Tipo Iva/Esenzione"
    @iva = Iva.find(params[:id])
  end

  def create
    @iva = Iva.new(params[:iva])
    @iva.aliq = 0 if @iva.flese == "S" # Se si tratta di esenzione l'aliquota viene impostata a 0

    if @iva.save
      redirect_to @iva, :notice => 'Codice Iva/Esenzione inserito con successo.'
    else
      @title = "Nuovo Tipo Iva/Esenzione"
      render action => "new"
    end
  end

  def update
    @iva = Iva.find(params[:id])
    @iva.aliq = 0 if @iva.flese == "S" # Se si tratta di esenzione l'aliquota viene impostata a 0

    if @iva.update_attributes(params[:iva])
      redirect_to @iva, :notice => 'Codice Iva/Esenzione aggiornato con successo.'
    else
      @title = "Modifica Tipo Iva/Esenzione"
      render action => "edit"
    end
  end

  def destroy
    @iva = Iva.find(params[:id])
    @iva.destroy
    redirect_to ivas_url
  end
end