class ArticlesController < ApplicationController
  def movmag
    if Article.movimentati(params[:id]).count == 0
      render 'movnotfound'
    else
      pdf = MovtitleController.render_pdf(:data => params[:id])
      send_data pdf, :type => "application/pdf",
                     :filename => "RpMovMagArt.pdf" 
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

  def movmagall
    if Article.movimentati("all").count == 0
      render 'movnotfound'
    else
      pdf = MovtitleController.render_pdf(:data => "all")
      send_data pdf, :type => "application/pdf",
                     :filename => "RpMovMagArt.pdf" 
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
    @articles = Article.paginate(:page => params[:page], :per_page => 25)
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
    @article.azienda = StaticData::AZIENDA
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
