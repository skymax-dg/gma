class AnagensController < ApplicationController

  before_filter :authenticate_request, if: :json_request?
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
    if params[:id].to_i > 0
      @anagen = Anagen.find(params[:id])
    elsif params[:id].to_i == -1
      @anagen = Anagen.random_author
    end
    @title = "Soggetto/Societa'"
    @art_author = @anagen.anagen_articles.by_author
    @art_print = @anagen.anagen_articles.by_printer
    #@tesdocs = @anagen.tesdocs.order(data_doc: :desc)
    @bookings = @anagen.prenotazioni
    @subscriptions = @anagen.abbonamenti
    @courses = @anagen.corsi

    @key_words_addable = KeyWord.sort_by_din(KeyWordAnagen.all)
    @articles_addable = Article.libri
    tmp = @anagen.contos.where(tipoconto: "C").first
    @eshop_orders = tmp ? tmp.tesdocs : []
    @coupons = @anagen.coupons
    @socials = @anagen.anag_socials

    respond_to do |format|
      format.html # renders .html.erb
      #format.json { render :json => { st: true, v: @anagen.to_json } }
      format.json { render json: map_json_result(@anagen) }
    end
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

  def change_article
    anagen = Anagen.find(params[:id])
    art_id = params[:article_id] && params[:article_id].to_i
    mode   = params[:mode] && params[:mode].to_i

    if mode == 1 
      st = anagen.connect_article(art_id)
    else 
      st = anagen.remove_article(art_id)
    end
    redirect_to :back, notice: st ? "Operazione completata" : "Operazione fallita"
  end

  def change_event
    anagen   = Anagen.find(params[:id])
    event_id = params[:event_id] && params[:event_id].to_i
    mode     = params[:mode] && params[:mode].to_i
    mode2    = params[:mode2] && params[:mode2].to_i

    if mode == 1 
      st = anagen.connect_event(event_id, mode2)
    else 
      st = anagen.remove_event(event_id, mode2)
    end
    redirect_to :back, notice: st ? "Operazione completata" : "Operazione fallita"
  end

  def authors
    ds = Anagen.authors.select("anagens.id, anagens.denomin, anagens.codnaz")
    render json: ds 
  end

  def teachers
    ds = Anagen.teachers.select("anagens.id, anagens.denomin, anagens.codnaz")
    render json: ds 
  end

  def anagens_query
    ds = Anagen.where(codfis: params[:codice])
    render json: map_json_array(ds, true)
  end

  private
    def force_fieldcase
      set_fieldcase(:anagen, [:codfis, :pariva, :fax, :telefono], [:email, :web])
    end

    def map_json_array(ds, min=false)
      ris = []
      ds.each do |x|
        ris << map_json_result(x,min)
      end
      ris
    end

    def map_json_result(x, min=false)
      a = min ? [:denomin] : [:bio, :denomin, :codnaz, :id, :codfis, :youtube_presentation]
      h = {}
      a.each { |y| h[y] = x[y] }
      h
    end
end
