class RigdocsController < ApplicationController
  def down
    @rigdoc = Rigdoc.find(params[:id])
    @rigdoc.move :down
    redirect_to @rigdoc.tesdoc
  end

  def up
    @rigdoc = Rigdoc.find(params[:id])
    @rigdoc.move :up
    redirect_to @rigdoc.tesdoc
  end

  def prezzoarticle
    @prezzo = Article.find(params[:rigdoc][:article_id]).prezzo unless params[:rigdoc][:article_id].empty? 
    @descriz = Article.find(params[:rigdoc][:article_id]).descriz unless params[:rigdoc][:article_id].empty? 
    respond_to do |format|
      format.js
    end
  end

  def create
    @tesdoc = Tesdoc.find(params[:rigdoc][:tesdoc_id])
    newprg = 1
    newprg = @tesdoc.rigdocs.last.prgrig + 1 unless  @tesdoc.rigdocs.empty?   
    @rigdoc = @tesdoc.rigdocs.build(params[:rigdoc])
    @rigdoc.prgrig = newprg
    if @rigdoc.save
      redirect_to @tesdoc, :notice => 'Riga documento aggiunta con successo.'
    else
      flash[:error] = "Il salvataggio della riga non e' andato a buon fine"
      render :action => :new
    end
  end

  def new
    @rigdoc = Tesdoc.find(params[:id]).rigdocs.build # La Build valorizza automaticamente il campo rigdoc.tesdoc_id
    @rigdoc.sconto = Tesdoc.find(params[:id]).sconto
    @rigdoc.qta = 1
  end

  def show
    @rigdoc = Rigdoc.find(params[:id])
  end

  def edit
    @rigdoc = Rigdoc.find(params[:id])
  end

  def update
    @rigdoc = Rigdoc.find(params[:id])
    if @rigdoc.update_attributes(params[:rigdoc])
      redirect_to @rigdoc, :notice => 'Testata documento modificata con successo.'
    else
      flash[:error] = "Il salvataggio della riga non e' andato a buon fine"
      render :action => "edit"
    end
  end

  def destroy
    @rigdoc = Rigdoc.find(params[:id])
    @rigdoc.destroy
    flash[:notice] = "Cancellazione Eseguita"
    redirect_to @rigdoc.tesdoc
  end
end
