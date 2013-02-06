class SpedizsController < ApplicationController
  before_filter :authenticate
  before_filter :force_fieldcase, :only => [:create, :update]

  def setind
    @anaind = Anaind.find(params[:spediz][:anaind_id])
    @des1 = @anaind.indir.strip
    @des2 = "#{@anaind.desloc}".strip
  end

  def show
    @title = "Mostra Dati spedizione/pagamento"
    @spediz = Spediz.find(params[:id])
  end

  def new
    @title = "Inserisci Dati spedizione/pagamento"
    @spediz = Tesdoc.find(params[:id]).build_spediz # La Build valorizza automaticamente il campo spediz.tesdoc_id
    @spediz.presso = Tesdoc.find(params[:id]).conto.anagen.denomin # Inizializzo il presso con la denominazione anagrafica
  end

  def edit
    @title = "Modifica Dati spedizione/pagamento"
    @spediz = Tesdoc.find(params[:id]).spediz
  end

  def create
    @spediz = Tesdoc.find(params[:spediz][:tesdoc_id]).build_spediz(params[:spediz])
    if @spediz.save
      flash[:success] = "Dati spedizione inseriti con successo."
      redirect_to :controller=>:tesdocs, :action=>:show, :id=>@spediz.tesdoc.id, :tab=>:sped
    else
      @title = "Inserisci Dati spedizione/pagamento"
      render 'new'
    end
  end

  def update
    @spediz = Spediz.find(params[:id])
    if @spediz.update_attributes(params[:spediz])
      flash[:success] = "Dati spedizione aggiornati."
      redirect_to :controller=>:tesdocs, :action=>:show, :id=>@spediz.tesdoc.id, :tab=>:sped
    else
      @title = "Modifica Dati spedizione/pagamento"
      render :action => "edit"
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

  private
    def force_fieldcase
      set_fieldcase(:spediz, [:pagamento, :banca], [])
    end
end
