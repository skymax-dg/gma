class AnagensController < ApplicationController

  before_filter :authenticate
  before_filter :force_fieldcase, :only => [:create, :update]

  def filter
    @tpfilter  = params[:tpfilter]
    @desfilter = params[:desfilter].strip
    @anagens, nrrecord = Anagen.filter(@tpfilter, @desfilter, params[:page])
    flash_cnt(nrrecord) if params[:page].nil?
    @title = "Elenco Soggetti/Societa'"
    render "index"
  end

  def index
    @title = "Elenco Soggetti/Societa'"
    store_location
    #@anagens = Anagen.paginate(:page => params[:page], :per_page => 10, :order => [:denomin])
  end

  def show
    @anagen = Anagen.find(params[:id])
    @title = "Soggetto/Societa'"
    @key_words_addable = KeyWord.sort_by_din(KeyWordAnagen.all)
  end

  def new
    @title = "Inserimento Soggetto/Societa'"
    @anagen = Anagen.new
    @anagen.codice = Anagen.newcod
  end

  def edit
    @anagen = Anagen.find(params[:id])
    @title = "Modifica Soggetto/Societa'"
  end

  def chg_tipo
    @anagen = Anagen.new
    @anagen.tipo = params[:anagen][:tipo]
    @anagen.dtnas = '01/01/1980' if @anagen.tipo == 'F' || @anagen.tipo == 'I'
    respond_to do |format|
      format.js
    end
  end

  def create
    @err=0
    respond_to do |format|
      @anagen = Anagen.new(params[:anagen])
      if @anagen.save
        if params[:ins_conto] == 'S'
          @conto = Conto.new
          @conto.azienda = current_user.azienda
          @conto.annoese = current_annoese
          @conto.tipoconto = 'C'
          @conto.codice = Conto.new_codice(@conto.annoese, @conto.azienda, @conto.tipoconto)
          @conto.descriz = @anagen.denomin
          @conto.cntrpartita = nil
          @conto.sconto = 0
          @conto.anagen_id = @anagen.id
          @conto.tipopeo = 'P'
          if @conto.save
            flash[:success] = 'Anagrafica soggetti e conto clienti creati con successo.'
          else
            flash[:error] = 'Anagrafica soggetti creata con successo. (PROBLEMI DURANTE LA CREAZIONE DEL CONTO CLIENTI)'
          end
        else
          flash[:success] = 'Anagrafica soggetti creata con successo.'
        end
      else
        @title = "Nuovo Soggetto/Societa'"
  #      flash.now[:alert] = "Il salvataggio dell'anagrafica non e' andato a buon fine"
        @err=1
      end
      @ins_conto = params[:ins_conto]
      format.js
    end
  end

  def createOLD
    @anagen = Anagen.new(params[:anagen])
    if @anagen.save
      if params[:ins_conto] == 'S'
        @conto = Conto.new
        @conto.azienda = current_user.azienda
        @conto.annoese = current_annoese
        @conto.tipoconto = 'C'
        @conto.codice = Conto.new_codice(@conto.annoese, @conto.azienda, @conto.tipoconto)
        @conto.descriz = @anagen.denomin
        @conto.cntrpartita = nil
        @conto.sconto = 0
        @conto.anagen_id = @anagen.id
        @conto.tipopeo = 'P'
        if @conto.save
          flash[:success] = 'Anagrafica soggetti e conto clienti creati con successo.'
        else
          flash[:error] = 'Anagrafica soggetti creata con successo. (PROBLEMI DURANTE LA CREAZIONE DEL CONTO CLIENTI)'
        end
      else
        flash[:success] = 'Anagrafica soggetti creata con successo.'
      end
      redirect_to @anagen
    else
      @title = "Nuovo Soggetto/Societa'"
#      flash.now[:alert] = "Il salvataggio dell'anagrafica non e' andato a buon fine"
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
#      flash.now[:alert] = "Il salvataggio dell'anagrafica non e' andato a buon fine"
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
redirect_back_or @anagen
  end

  private
    def force_fieldcase
      set_fieldcase(:anagen, [:codfis, :pariva, :fax, :telefono], [:email, :web])
    end
end
