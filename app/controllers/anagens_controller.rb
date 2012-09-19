class AnagensController < ApplicationController
before_filter :authenticate
  def filter
    @title = "Elenco Soggetti/Societa'"
    @tpfilter  = params[:tpfilter]
    @desfilter = params[:desfilter].strip
    @anagens = Anagen.filter(@tpfilter, @desfilter, params[:page])
    render "index"
  end

  def index
    @title = "Elenco Soggetti/Societa'"
    #@anagens = Anagen.paginate(:page => params[:page], :per_page => 10, :order => [:denomin])
  end

  def show
    @title = "Mostra Soggetto/Societa'"
    @anagen = Anagen.find(params[:id])
  end

  def new
    @title = "Nuovo Soggetto/Societa'"
    @anagen = Anagen.new
    @anagen.codice = Anagen.newcod
  end

  def edit
    @title = "Modifica Soggetto/Societa'"
    @anagen = Anagen.find(params[:id])
  end

  def chg_tipo
    @anagen = Anagen.new
    @anagen.tipo = params[:anagen][:tipo]
    respond_to do |format|
      format.js
    end
  end

  def create
    @anagen = Anagen.new(params[:anagen])
    if @anagen.save
      if params[:ins_conto] == 'S'
        @conto = Conto.new
        @conto.azienda = current_user.azienda
        @conto.annoese = current_annoese
        @conto.codice = Conto.new_codice(@conto.annoese, @conto.azienda)
        @conto.descriz = @anagen.denomin
        @conto.tipoconto = 'C'
        @conto.cntrpartita = nil
        @conto.sconto = 0
        @conto.anagen_id = @anagen.id
        @conto.tipopeo = 'P'
        if @conto.save
          flash[:success] = 'Anagrafica soggetti e conto clienti creati con successo.'
        else
          flash[:success] = 'Anagrafica soggetti creata con successo. (PROBLEMI DURANTE LA CREAZIONE DEL CONTO CLIENTI)'
        end
      else
        flash[:success] = 'Anagrafica soggetti creata con successo.'
      end
      redirect_to @anagen
    else
      @title = "Nuovo Soggetto/Societa'"
#      flash[:alert] = "Il salvataggio dell'anagrafica non e' andato a buon fine"
      render :action => "new"
    end
  end

  def update
    @anagen = Anagen.find(params[:id])
    if @anagen.update_attributes(params[:anagen])
      flash[:success] = 'Anagrafica soggetti aggiornata con successo.'
      redirect_to @anagen
    else
      @title = "Modifica Soggetto/Societa'"
#      flash[:alert] = "Il salvataggio dell'anagrafica non e' andato a buon fine"
      render :action => "edit"
    end
  end

  def destroy
    @anagen = Anagen.find(params[:id])
    begin
      @anagen.destroy
      flash[:success] = "Cancellazione Eseguita"
    rescue
      flash[:alert] = $!.message
    end
    redirect_to @anagen
  end
end
