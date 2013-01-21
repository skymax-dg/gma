class AgentesController < ApplicationController
  def index
    @title = "Elenco Agenti"
    flash_cnt(Agente.count) if params[:page].nil?
    @agentes = Agente.paginate(:page => params[:page], :per_page => 10, :include => :anagen, :order => "anagens.denomin")
    store_location
  end

  def new
    @title = "Nuovo Agente"
    @agente = Agente.new
  end

  def edit
    @title = "Modifica Agente"
    @agente = Agente.find(params[:id])
  end

  def create
    @agente = Agente.new(params[:agente])
    @agente.provv = 0 unless @agente.provv

    if @agente.save
      flash[:success] = 'Agente inserito con successo.'
      redirect_to agentes_path
    else
      @title = "Nuovo Agente"
      render :new
    end
  end

  def update
    @agente = Agente.find(params[:id])
    @agente.provv = 0 unless @agente.provv

    if @agente.update_attributes(params[:agente])
      flash[:success] = 'Agente aggiornato con successo.'
      redirect_to agentes_path
    else
      @title = "Modifica agente"
      render :edit
    end
  end

  def destroy
    @agente = Agente.find(params[:id])
    begin
      @agente.destroy
      flash[:success] = "Cancellazione Eseguita"
    rescue
      flash[:alert] = $!.message
    end
    redirect_back_or agentes_path
  end
end