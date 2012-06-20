class ArticlesController < ApplicationController
  def filter_movmag
    @article = Article.find(params[:id]) unless params[:id].nil?
    @anagens = Anagen.findbytpconto(current_user.azienda, 'C')
    @contos = Conto.findbytipoconto(current_user.azienda, current_annoese, "C")
    if @anagens.empty?
      flash[:error] = "Nessun conto cliente presente"
      render :action => "show"
    end
  end

  def filter_movmagall
    @anagens = Anagen.findbytpconto(current_user.azienda, 'C')
    @contos = Conto.findbytipoconto(current_user.azienda, current_annoese, "C")
    if @anagens.empty?
      flash[:error] = "Nessun conto cliente presente"
      render :action => "index"
    end
  end

  def stp_movmag
    pdfdata = Tesdoc.art_mov(params[:id], params[:idanagen], params[:nrmag], params[:anarif], current_user.azienda)
    if pdfdata.count == 0
      render 'movnotfound'
    else
      pdf = MovtitleController.render_pdf(:data     => pdfdata, 
                                          :idanagen => params[:idanagen]||"", :nrmag  => params[:nrmag]||"",
                                          :anarif   => params[:anarif]||"",   :grpmag => params[:grpmag]||"",
                                          :azienda  => current_user.azienda)
      send_data pdf, :type => "application/pdf",
                     :filename => "RpMovMagArt.pdf"
    end
  end

  def stp_movmagOLD
    pdfdata = Tesdoc.art_mov(params[:id], params[:idconto], params[:nrmag], params[:anarif])
    if pdfdata.count == 0
      render 'movnotfound'
    else
      pdf = MovtitleController.render_pdf(:data    => pdfdata, 
                                          :idconto => params[:idconto]||"", :nrmag  => params[:nrmag]||"",
                                          :anarif  => params[:anarif]||"",  :grpmag => params[:grpmag]||"")
      send_data pdf, :type => "application/pdf",
                     :filename => "RpMovMagArt.pdf" 
    end
  end

  def stp_movmagall
    pdfdata = Tesdoc.art_mov("all", params[:idanagen], params[:nrmag], params[:anarif], current_user.azienda)
    if pdfdata.count == 0
      render 'movnotfound'
    else
      pdf = MovtitleController.render_pdf(:data     => pdfdata, 
                                          :idanagen => params[:idanagen]||"", :nrmag  => params[:nrmag]||"",
                                          :anarif   => params[:anarif]||"",   :grpmag => params[:grpmag]||"",
                                          :azienda  => current_user.azienda)
      send_data pdf, :type => "application/pdf",
                     :filename => "RpMovMagAllArt.pdf" 
    end
  end

  def cvendis
    if Article.titcvend(params[:id]).count == 0
      render 'cvenddistnotfound'
    else
      pdf = CvendistitleController.render_pdf(:data => params[:id])
      send_data pdf, :type => "application/pdf",
                     :filename => "RpCVenDistArt.pdf" 
    end
  end

  def cvendisall
    if Article.titcvend("all").count == 0
      render 'cvenddistnotfound'
    else
      pdf = CvendistitleController.render_pdf(:data => "all")
      send_data pdf, :type => "application/pdf",
                     :filename => "RpCVenDistArt.pdf" 
    end
  end

  def index
    @articles = Article.azienda(current_user.azienda).paginate(:page => params[:page], :per_page => 25)
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
