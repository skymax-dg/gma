class CostosController < ApplicationController

  before_filter :authenticate

  def show
    @title = "Mostra costo spedizione"
    @costo = Costo.find(params[:id])
  end

  def new
    @title = "Inserisci costo spedizione"
    @costo = Tesdoc.find(params[:id]).build_costo # La Build valorizza automaticamente il campo costo.tesdoc_id
  end

  def edit
    @title = "Modifica costo spedizione"
    @costo = Tesdoc.find(params[:id]).costo
  end

  def create
    params[:costo][:data]=params[:costo][:data].to_my_date if params[:costo][:data]&&params[:costo][:data].is_date?
    @costo = Tesdoc.find(params[:costo][:tesdoc_id]).build_costo(params[:costo])
    if @costo.save
      flash[:success] = "Dati costo spedizone inseriti con successo."
      redirect_to :controller=>:tesdocs, :action=>:show, :id=>@costo.tesdoc.id, :tab=>:costo
      #redirect_to @costo.tesdoc
    else
      @title = "Inserisci dati costo spedizone"
#      flash.now[:alert] = "Il salvataggio dei dati costo non e' andato a buon fine"
      render 'new'
    end
  end

  def update
# la riga seguente è da rivedere ed implementare un custom validate
params[:costo][:data]=params[:costo][:data].to_my_date if params[:costo][:data]&&params[:costo][:data].is_date?
    @costo = Costo.find(params[:id])
    if @costo.update_attributes(params[:costo])
      flash[:success] = "Dati costo spedizione aggiornati."
      redirect_to :controller=>:tesdocs, :action=>:show, :id=>@costo.tesdoc.id, :tab=>:costo
      #redirect_to @costo.tesdoc
    else
      @title = "Modifica dati costo spedizone"
#      flash.now[:alert] = "Il salvataggio dei dati costo non e' andato a buon fine"
      render :action => "edit"
    end
  end

  def destroy
    begin
      @costo=Costo.find(params[:id])
      @costo.destroy
      flash[:success] = "Cancellazione costo spedizione Eseguita"
    rescue
      flash[:alert] = $!.message
    end
    redirect_to :controller=>:tesdocs, :action=>:show, :id=>@costo.tesdoc_id, :tab=>:costo
  end

end
