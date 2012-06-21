class ArticlesController < ApplicationController
  def filter_movmag
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

  def filter_movmagall
    @tp = params[:tp]
    @anagens = Anagen.findbytpconto(current_user.azienda, 'C')
    @contos = Conto.findbytipoconto(current_user.azienda, current_annoese, "C")
    if @anagens.empty?
      flash[:error] = "Nessun conto cliente presente"
      render :action => "index"
    end
    @tp == "M" ? @title = "Stampa Movimenti di magazzino" : @title = "Stampa Vendite per titolo"
  end

  def stp_movmag
    @tp = params[:tp]
    pdfdata = Tesdoc.art_mov_vend(params[:id],     params[:idanagen],    params[:nrmag],
                                  params[:anarif], current_user.azienda, @tp)
    if pdfdata.count == 0
      render 'mov_vend_notfound'
    else
      pdf = MovtitleController.render_pdf(:data     => pdfdata, 
                                          :idanagen => params[:idanagen]||"", :nrmag  => params[:nrmag]||"",
                                          :anarif   => params[:anarif]||"",   :grpmag => params[:grpmag]||"",
                                          :azienda  => current_user.azienda,  :tp => @tp)
      if @tp == "M"
        send_data pdf, :type => "application/pdf",
                       :filename => "RpMovArt.pdf"
      else
        send_data pdf, :type => "application/pdf",
                       :filename => "RpVendArt.pdf"
      end
    end
  end

  def stp_movmagall
    @tp = params[:tp]
    pdfdata = Tesdoc.art_mov_vend("all", params[:idanagen], params[:nrmag], params[:anarif], current_user.azienda, @tp)
    if pdfdata.count == 0
      render 'mov_vend_notfound'
    else
      pdf = MovtitleController.render_pdf(:data     => pdfdata, 
                                          :idanagen => params[:idanagen]||"", :nrmag  => params[:nrmag]||"",
                                          :anarif   => params[:anarif]||"",   :grpmag => params[:grpmag]||"",
                                          :azienda  => current_user.azienda,  :tp => @tp)
      if @tp == "M"
        send_data pdf, :type => "application/pdf",
                       :filename => "RpMovAllArt.pdf" 
      else
        send_data pdf, :type => "application/pdf",
                       :filename => "RpVendAllArt.pdf"
      end
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
