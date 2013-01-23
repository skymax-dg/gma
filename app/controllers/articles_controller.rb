require "prawn"
require "prawn/measurement_extensions"

class ArticlesController < ApplicationController

  before_filter :authenticate
  before_filter :force_fieldcase, :only => [:create, :update]

  def filter_mov_vend
    @tp = params[:tp]
    @article = Article.find(params[:id]) unless params[:id].nil?
    @anagens = Anagen.findbytpconto(current_user.azienda, 'C')
    @contos = Conto.findbytipoconto(current_user.azienda, current_annoese, "C")
    if @anagens.empty?
      flash.now[:alert] = "Nessun conto cliente presente"
      render :action => "show"
    end
    @tp == "M" ? @title = "Stampa Movimenti di magazzino" : @title = "Stampa Vendite per titolo"
    @all = false
  end

  def filter_mov_vend_xls
    @tp = params[:tp]
    @article = Article.find(params[:id]) unless params[:id].nil?
    @anagens = Anagen.findbytpconto(current_user.azienda, 'C')
    @contos = Conto.findbytipoconto(current_user.azienda, current_annoese, "C")
    if @anagens.empty?
      flash.now[:alert] = "Nessun conto cliente presente"
      render :action => "show"
    end
    @tp == "M" ? @title = "Export (XLS) Movimenti di magazzino" : @title = "Export (XLS) Vendite per titolo"
    @all = false
  end

  def filter_mov_vend_all
    @tp = params[:tp]
    @anagens = Anagen.findbytpconto(current_user.azienda, 'C')
    @contos = Conto.findbytipoconto(current_user.azienda, current_annoese, "C")
    if @anagens.empty?
      flash.now[:alert] = "Nessun conto cliente presente"
      render :action => "index"
    end
    @tp == "M" ? @title = "Stampa Movimenti di magazzino" : @title = "Stampa Vendite per titolo"
    @all = true
  end

  def filter_mov_vend_all_xls
    @tp = params[:tp]
    @anagens = Anagen.findbytpconto(current_user.azienda, 'C')
    @contos = Conto.findbytipoconto(current_user.azienda, current_annoese, "C")
    if @anagens.empty?
      flash.now[:alert] = "Nessun conto cliente presente"
      render :action => "index"
    end
    @tp == "M" ? @title = "Export (XLS) Movimenti di magazzino" : @title = "Export (XLS) Vendite per titolo"
    @all = true
  end

  def stp_mov_vend
    @tp = params[:tp]
    @id = params[:id]||""
    @idanagen = params[:idanagen]||""
    @nrmag = params[:nrmag]||""
    @anarif = params[:anarif]||""
    @grpmag = params[:grpmag]||""
    @annoese = current_annoese
    @artmov = Tesdoc.art_mov_vend(@id, @idanagen, @nrmag,
                                  @anarif, current_user.azienda, @tp, @annoese)
    @tp == "M" ? @title = "Stampa Movimenti di magazzino" : @title = "Stampa Vendite per titolo"
    if @artmov.count == 0
      render 'mov_vend_notfound'
    else
      render 'stp_mov_vend.pdf'
    end
  end

  def stp_mov_vend_all
    @tp = params[:tp]
    @idanagen = params[:idanagen]||""
    @nrmag = params[:nrmag]||""
    @anarif = params[:anarif]||""
    @grpmag = params[:grpmag]||""
    @annoese = current_annoese
    @artmov = Tesdoc.art_mov_vend("all", @idanagen, @nrmag,
                                  @anarif, current_user.azienda, @tp, @annoese)
    @tp == "M" ? @title = "Stampa Movimenti di magazzino" : @title = "Stampa Vendite per titolo"
    if @artmov.count == 0
      render 'mov_vend_notfound'
    else
      render 'stp_mov_vend.pdf'
    end
  end

  def mov_vend_xls
    @tp = params[:tp]
    @id = params[:id]||""
    @idanagen = params[:idanagen]||""
    @nrmag = params[:nrmag]||""
    @anarif = params[:anarif]||""
    @grpmag = params[:grpmag]||""

    @artmov = Tesdoc.art_mov_vend(@id, @idanagen, @nrmag,
                                  @anarif, current_user.azienda, @tp, current_annoese)
    @tp == "M" ? @title = "Export (XLS) Movimenti di magazzino" : @title = "Export (XLS) Vendite per titolo"
    if @artmov.count == 0
      render 'mov_vend_notfound'
    else
      data=Article.exp_movart_xls(@tp, @artmov, @idanagen, @nrmag, @anarif, current_user.azienda, @grpmag, current_annoese)
      send_data(data, {
        :disposition => 'attachment',
        :encoding => 'utf8',
        :stream => false,
        :type => 'application/excel',
        :filename => './mov_art.xls'})
    end
  end

  def mov_vend_all_xls
    @tp = params[:tp]
    @idanagen = params[:idanagen]||""
    @nrmag = params[:nrmag]||""
    @anarif = params[:anarif]||""
    @grpmag = params[:grpmag]||""
    @artmov = Tesdoc.art_mov_vend("all", @idanagen, @nrmag,
                                  @anarif, current_user.azienda, @tp, current_annoese)
    @tp == "M" ? @title = "Export (XLS) Movimenti di magazzino" : @title = "Export (XLS) Vendite per titolo"
    if @artmov.count == 0
      render 'mov_vend_notfound'
    else
      data=Article.exp_movart_xls(@tp, @artmov, @idanagen, @nrmag, @anarif, current_user.azienda, @grpmag, current_annoese)
      send_data(data, {
        :disposition => 'attachment',
        :encoding => 'utf8',
        :stream => false,
        :type => 'application/excel',
        :filename => './mov_art.xls'})
    end
  end

  def filter
    @title = "Elenco Articoli"
    @tpfilter  = params[:tpfilter]
    @desfilter = params[:desfilter].strip
    @articles, nrrecord = Article.filter(@tpfilter, @desfilter, params[:page])
    flash_cnt(nrrecord) if params[:page].nil?
store_location
    render "index"
  end

  def index
    @title = "Elenco Articoli"
store_location
  end

  def show
    @title = "Mostra Articolo"
    @article = Article.find(params[:id])
  end

  def new
    @title = "Nuovo Articolo"
    @article = Article.new
    @article.azienda = current_user.azienda
  end

  def edit
    @title = "Modifica Articolo"
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(params[:article])
    if @article.save
      flash[:success] = 'Articolo inserito con successo.'
      redirect_to @article
    else
      @title = "Nuovo Articolo"
#      flash.now[:alert] = "Il salvataggio dell'articolo non e' andato a buon fine"
      render :action => "new"
    end
  end

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      flash[:success] = 'Articolo aggiornato con successo.'
      redirect_to @article
    else
      @title = "Modifica Articolo"
#      flash.now[:alert] = "Il salvataggio dell'articolo non e' andato a buon fine"
      render :action => "edit"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    begin
      @article.destroy
      flash[:success] = "Cancellazione Eseguita"
    rescue
      flash[:alert] = $!.message
    end
redirect_back_or @article
  end

  private
    def force_fieldcase
      set_fieldcase(:article, [:codice], [])
    end
end
