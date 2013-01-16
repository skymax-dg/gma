class ScadenzasController < ApplicationController

  before_filter :authenticate

  def new
    @title = "Nuova Scadenza documento"
    @scadenza = Tesdoc.find(params[:id]).scadenzas.build # La Build valorizza automaticamente il campo scadenza.tesdoc_id
  end

  def create
    @tesdoc = Tesdoc.find(params[:scadenza][:tesdoc_id])
    @scadenza = @tesdoc.scadenzas.build(params[:scadenza])
    if @scadenza.save
      flash[:success] = "Scadenza documento aggiunta con successo."
      redirect_to @tesdoc
    else
      @title = "Nuova Scadenza documento"
      flash.now[:alert] = "Il salvataggio non e' andato a buon fine"
      render 'new'
    end
  end

#  def show
#    @title = "Mostra scadenza"
#    @scadenza = Scadenza.find(params[:id])
#  end

  def edit
    @title = "Modifica Scadenza"
    @scadenza = Scadenza.find(params[:id])
  end

  def update
    @scadenza = Scadenza.find(params[:id])
    if @scadenza.update_attributes(params[:scadenza])
      flash[:success] = "Scadenza modificata con successo."
      redirect_to :controller=>:tesdocs, :action=>:show, :id=>@scadenza.tesdoc.id, :tab=>:scad
    else
      @title = "Modifica Scadenza"
      flash.now[:alert] = "Il salvataggio non e' andato a buon fine"
      render 'edit'
    end
  end

  def destroy
    @spediz = Spediz.find(params[:id])
    begin
      @spediz.destroy
      flash[:success] = "Cancellazione Eseguita"
    rescue
      flash[:alert] = $!.message
    end
    redirect_to @spediz
  end
end
