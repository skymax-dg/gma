require "prawn"
require "prawn/measurement_extensions"

class ArticlesController < ApplicationController

  before_filter :authenticate
  before_filter :force_fieldcase, :only => [:create, :update]

  def set_distrib
    @fl_dis = params[:anarif]=='S'
    @contos = Conto.find_distributori(current_user.azienda, current_annoese)
    respond_to do |format|
      format.js
    end
  end

  def filter_mov_vend
    @tp = params[:tp]
    @article = Article.find(params[:id]) unless params[:id].nil?
    @contos = Conto.find_distributori(current_user.azienda, current_annoese)
    if @contos.empty?
      flash.now[:alert] = "Nessun conto cliente presente"
      render :action => "show"
    end
    if @tp == "M"
      @title = "Stampa Movimenti di magazzino"
      @causmags = Causmag.azienda(current_user.azienda).all(:order=>:descriz)
    else
      @title = "Stampa Vendite per titolo"
      @causmags = Causmag.azienda(current_user.azienda).all(:conditions=>{:contabile=>'S'}, :order=>:descriz)
    end
    @all = false
    @fl_dis = true
  end

  def filter_mov_vend_xls
    @tp = params[:tp]
    @article = Article.find(params[:id]) unless params[:id].nil?
    @contos = Conto.find_distributori(current_user.azienda, current_annoese)
    if @contos.empty?
      flash.now[:alert] = "Nessun conto cliente presente"
      render :action => "show"
    end
    if @tp == "M"
      @title = "Export (XLS) Movimenti di magazzino"
      causmags = Causmag.azienda(current_user.azienda).all(:order=>:descriz)
    else
      @title = "Export (XLS) Vendite per titolo"
      @causmags = Causmag.azienda(current_user.azienda).all(:conditions=>{:contabile=>'S'}, :order=>:descriz)
    end
    @all = false
    @fl_dis = true
  end

  def filter_mov_vend_all
    @tp = params[:tp]
    @contos = Conto.find_distributori(current_user.azienda, current_annoese)
    if @contos.empty?
      flash.now[:alert] = "Nessun conto cliente presente"
      render :action => "index"
    end
    if @tp == "M"
      @title = "Stampa Movimenti di magazzino"
      @causmags = Causmag.azienda(current_user.azienda).all(:order=>:descriz)
    else
      @title = "Stampa Vendite per titolo"
      @causmags = Causmag.azienda(current_user.azienda).all(:conditions=>{:contabile=>'S'}, :order=>:descriz)
    end
    @all = true
    @fl_dis = true
  end

  def filter_mov_vend_all_xls
    @tp = params[:tp]
    @contos = Conto.find_distributori(current_user.azienda, current_annoese)
    if @contos.empty?
      flash.now[:alert] = "Nessun conto cliente presente"
      render :action => "index"
    end
    if @tp == "M"
      @title = "Export (XLS) Movimenti di magazzino"
      @causmags = Causmag.azienda(current_user.azienda).all(:order=>:descriz)
    else
      @title = "Export (XLS) Vendite per titolo"
      @causmags = Causmag.azienda(current_user.azienda).all(:conditions=>{:contabile=>'S'}, :order=>:descriz)
    end
    @all = true
    @fl_dis = true
  end

  def stp_mov_vend
    @tp = params[:tp]
    @id = params[:id]||""
    @idanagen = params[:idconto].to_i>0 ? Conto.find(params[:idconto]).anagen.id : ""
    @nrmag = params[:nrmag]||""
    @anarif = params[:anarif]||""
    @grpmag = params[:grpmag]||""
    @dtini = params[:dtini].to_date if params[:dtini]
    @dtfin = params[:dtfin].to_date if params[:dtfin]
    @idcausmag = params[:causmagfilter]
    @annoese = current_annoese
    @artmov = Tesdoc.art_mov_vend(@id, @idanagen, @nrmag, @anarif, current_user.azienda,
                                  @tp, @annoese, @dtini, @dtfin, @idcausmag)
    @tp == "M" ? @title = "Stampa Movimenti di magazzino" : @title = "Stampa Vendite per titolo"
    if @artmov.count == 0
      render 'mov_vend_notfound'
    else
      render 'stp_mov_vend.pdf'
    end
  end

  def stp_mov_vend_all
    @tp = params[:tp]
    @idanagen = params[:idconto].to_i>0 ? Conto.find(params[:idconto]).anagen.id : ""
    @nrmag = params[:nrmag]||""
    @anarif = params[:anarif]||""
    @grpmag = params[:grpmag]||""
    @dtini = params[:dtini].to_date if params[:dtini]
    @dtfin = params[:dtfin].to_date if params[:dtfin]
    @idcausmag = params[:causmagfilter]
    @annoese = current_annoese
    @artmov = Tesdoc.art_mov_vend("all", @idanagen, @nrmag, @anarif, current_user.azienda,
                                         @tp, @annoese, @dtini, @dtfin, @idcausmag)
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
    @idanagen = params[:idconto].to_i>0 ? Conto.find(params[:idconto]).anagen.id : ""
    @nrmag = params[:nrmag]||""
    @anarif = params[:anarif]||""
    @grpmag = params[:grpmag]||""
    @dtini = params[:dtini].to_date if params[:dtini]
    @dtfin = params[:dtfin].to_date if params[:dtfin]
    @idcausmag = params[:causmagfilter]
    @artmov = Tesdoc.art_mov_vend(@id, @idanagen, @nrmag, @anarif, current_user.azienda,
                                  @tp, current_annoese, @dtini, @dtfin, @idcausmag)
    @tp == "M" ? @title = "Export (XLS) Movimenti di magazzino" : @title = "Export (XLS) Vendite per titolo"
    if @artmov.count == 0
      render 'mov_vend_notfound'
    else
      data=Article.exp_movart_xls(@tp, @artmov, @idanagen, @nrmag, @anarif, current_user.azienda,
                                  @grpmag, current_annoese, @dtini, @dtfin, @idcausmag)
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
    @idanagen = params[:idconto].to_i>0 ? Conto.find(params[:idconto]).anagen.id : ""
    @nrmag = params[:nrmag]||""
    @anarif = params[:anarif]||""
    @grpmag = params[:grpmag]||""
    @dtini = params[:dtini].to_date if params[:dtini]
    @dtfin = params[:dtfin].to_date if params[:dtfin]
    @idcausmag = params[:causmagfilter]||""
    @artmov = Tesdoc.art_mov_vend("all", @idanagen, @nrmag, @anarif, current_user.azienda,
                                         @tp, current_annoese, @dtini, @dtfin, @idcausmag)
    @tp == "M" ? @title = "Export (XLS) Movimenti di magazzino" : @title = "Export (XLS) Vendite per titolo"
    if @artmov.count == 0
      render 'mov_vend_notfound'
    else
      data=Article.exp_movart_xls(@tp, @artmov, @idanagen, @nrmag, @anarif, current_user.azienda,
                                  @grpmag, current_annoese, @dtini, @dtfin, @idcausmag)
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
    @articles, nrrecord = Article.filter(current_user.azienda, @tpfilter, @desfilter, params[:page])
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
    @article.costo = 0.0
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
