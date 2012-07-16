require "prawn"
#require "prawn/layout"
require "prawn/measurement_extensions"

class ArticlesController < ApplicationController
before_filter :authenticate
  def filter_mov_vend
    @tp = params[:tp]
    @article = Article.find(params[:id]) unless params[:id].nil?
    @anagens = Anagen.findbytpconto(current_user.azienda, 'C')
    @contos = Conto.findbytipoconto(current_user.azienda, current_annoese, "C")
    if @anagens.empty?
      flash[:error] = "Nessun conto cliente presente"
      render :action => "show"
    end
    @tp == "M" ? @title = "Stampa Movimenti di magazzino" : @title = "Stampa Vendite per titolo"
  end

  def filter_mov_vend_xls
    @tp = params[:tp]
    @article = Article.find(params[:id]) unless params[:id].nil?
    @anagens = Anagen.findbytpconto(current_user.azienda, 'C')
    @contos = Conto.findbytipoconto(current_user.azienda, current_annoese, "C")
    if @anagens.empty?
      flash[:error] = "Nessun conto cliente presente"
      render :action => "show"
    end
    @tp == "M" ? @title = "Export (XLS) Movimenti di magazzino" : @title = "Export (XLS) Vendite per titolo"
  end

  def filter_mov_vend_all
    @tp = params[:tp]
    @anagens = Anagen.findbytpconto(current_user.azienda, 'C')
    @contos = Conto.findbytipoconto(current_user.azienda, current_annoese, "C")
    if @anagens.empty?
      flash[:error] = "Nessun conto cliente presente"
      render :action => "index"
    end
    @tp == "M" ? @title = "Stampa Movimenti di magazzino" : @title = "Stampa Vendite per titolo"
  end

  def filter_mov_vend_all_xls
    @tp = params[:tp]
    @anagens = Anagen.findbytpconto(current_user.azienda, 'C')
    @contos = Conto.findbytipoconto(current_user.azienda, current_annoese, "C")
    if @anagens.empty?
      flash[:error] = "Nessun conto cliente presente"
      render :action => "index"
    end
    @tp == "M" ? @title = "Export (XLS) Movimenti di magazzino" : @title = "Export (XLS) Vendite per titolo"
  end

  def stp_mov_vend
    @tp = params[:tp]
    @id = params[:id]||""
    @idanagen = params[:idanagen]||""
    @nrmag = params[:nrmag]||""
    @anarif = params[:anarif]||""
    @grpmag = params[:grpmag]||""

    @artmov = Tesdoc.art_mov_vend(@id, @idanagen, @nrmag,
                                  @anarif, current_user.azienda, @tp)
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
    @artmov = Tesdoc.art_mov_vend("all", @idanagen, @nrmag,
                                  @anarif, current_user.azienda, @tp)
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
                                  @anarif, current_user.azienda, @tp)
    if @artmov.count == 0
      render 'mov_vend_notfound'
    else
      exp_movart_xls(@tp, @artmov, @idanagen, @nrmag, @anarif, @grpmag)
    end
  end

  def mov_vend_all_xls
    @tp = params[:tp]
    @idanagen = params[:idanagen]||""
    @nrmag = params[:nrmag]||""
    @anarif = params[:anarif]||""
    @grpmag = params[:grpmag]||""
    @artmov = Tesdoc.art_mov_vend("all", @idanagen, @nrmag,
                                  @anarif, current_user.azienda, @tp)
    if @artmov.count == 0
      render 'mov_vend_notfound'
    else
      exp_movart_xls(@tp, @artmov, @idanagen, @nrmag, @anarif, @grpmag)
    end
  end

  def index
    @articles = Article.azienda(current_user.azienda).paginate(:page => params[:page], :per_page => 25, :order => [:codice])
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
    @article.azienda = current_user.azienda
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(params[:article])
    if @article.save
      redirect_to @article, :notice => 'Articolo inserito con successo.'
    else
      flash[:error] = "Il salvataggio dell'articolo non e' andato a buon fine"
      render :action => "new"
    end
  end

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      redirect_to @article, :notice => 'Articolo aggiornato con successo.'
    else
      flash[:error] = "Il salvataggio dell'articolo non e' andato a buon fine"
      render :action => "edit"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    begin
      @article.destroy
      flash[:notice] = "Cancellazione Eseguita"
    rescue
      flash[:error] = $!.message
    end
    redirect_to articles_url
  end

end
