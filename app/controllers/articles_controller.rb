class ArticlesController < ApplicationController
  def index
    @articles = Article.paginate(:page => params[:page], :per_page => 10)
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
      redirect_to @article, :notice => 'Article was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      redirect_to @article, :notice => 'Article was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_url
  end
end
