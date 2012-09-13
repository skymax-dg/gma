class SpedizsController < ApplicationController
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
    params[:spediz][:dtrit]=params[:spediz][:dtrit].to_my_date if params[:spediz][:dtrit].is_date?
    @spediz = Tesdoc.find(params[:spediz][:tesdoc_id]).build_spediz(params[:spediz])
    if @spediz.save
      redirect_to @spediz.tesdoc, :notice => 'Dati spedizione inseriti con successo.'
    else
      @title = "Inserisci Dati spedizione/pagamento"
      flash[:alert] = "Il salvataggio dei dati spedizione non e' andato a buon fine"
      render 'new'
    end
  end

  def update
# la riga seguente è da rivedere ed implementare un custom validate
params[:spediz][:dtrit]=params[:spediz][:dtrit].to_my_date if params[:spediz][:dtrit].is_date?
    @spediz = Spediz.find(params[:id])
    if @spediz.update_attributes(params[:spediz])
      redirect_to @spediz.tesdoc, :notice => 'Dati spedizione aggiornati.'
    else
      @title = "Modifica Dati spedizione/pagamento"
      flash[:alert] = "Il salvataggio dei dati spedizione non e' andato a buon fine"
      render :action => "edit"
    end
  end

  def destroy
    @spediz = Spediz.find(params[:id])
    @spediz.destroy
  end
end
