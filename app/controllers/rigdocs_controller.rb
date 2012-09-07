class RigdocsController < ApplicationController
before_filter :authenticate
  def down
    @rigdoc = Rigdoc.find(params[:id])
    @rigdoc.move :down
    redirect_to tesdoc_url(@rigdoc.tesdoc.id, :page=>params[:page])
  end

  def up
    @rigdoc = Rigdoc.find(params[:id])
    @rigdoc.move :up
    redirect_to tesdoc_url(@rigdoc.tesdoc.id, :page=>params[:page])
  end

  def article_exit
    @prezzo = Article.find(params[:rigdoc][:article_id]).prezzo unless params[:rigdoc][:article_id].empty? 
    @descriz = Article.find(params[:rigdoc][:article_id]).descriz unless params[:rigdoc][:article_id].empty? 
    @des_plus = Article.find(params[:rigdoc][:article_id]).des_plus unless params[:rigdoc][:article_id].empty? 
    @iva_id = Article.find(params[:rigdoc][:article_id]).iva_id unless params[:rigdoc][:article_id].empty? 
    respond_to do |format|
      format.js
    end
  end

  def descrizriga
    @desriga = Article.find(params[:rigdoc][:article_id]).descriz unless params[:rigdoc][:article_id].empty? 
    @descriz = Article.find(params[:rigdoc][:article_id]).descriz unless params[:rigdoc][:article_id].empty? 
    respond_to do |format|
      format.js
    end
  end

  def new
    @title = "Nuova Riga documento"
    @rigdoc = Tesdoc.find(params[:id]).rigdocs.build # La Build valorizza automaticamente il campo rigdoc.tesdoc_id
    @rigdoc.sconto = Tesdoc.find(params[:id]).sconto
    @rigdoc.iva_id = Tesdoc.find(params[:id]).iva_id
    @rigdoc.qta = 1
  end

  def create
    @tesdoc = Tesdoc.find(params[:rigdoc][:tesdoc_id])
    newprg = @tesdoc.lastprgrig + 1
    @rigdoc = @tesdoc.rigdocs.build(params[:rigdoc])
    @rigdoc.prgrig = newprg
    if @rigdoc.save
      redirect_to @tesdoc, :notice => 'Riga documento aggiunta con successo.'
    else
      @title = "Nuova Riga documento"
      flash[:error] = "Il salvataggio della riga non e' andato a buon fine"
      render 'new'
    end
  end

  def show
    @title = "Mostra Riga documento"
    @rigdoc = Rigdoc.find(params[:id])
  end

  def edit
    @title = "Modifica Riga documento"
    @rigdoc = Rigdoc.find(params[:id])
  end

  def update
    @rigdoc = Rigdoc.find(params[:id])
    if @rigdoc.update_attributes(params[:rigdoc])
      redirect_to @rigdoc, :notice => 'Testata documento modificata con successo.'
    else
      @title = "Modifica Riga documento"
      flash[:error] = "Il salvataggio della riga non e' andato a buon fine"
      render 'edit'
    end
  end

  def destroy
    @rigdoc = Rigdoc.find(params[:id])
    @rigdoc.destroy
    flash[:notice] = "Cancellazione Eseguita"
    redirect_to @rigdoc.tesdoc
  end
end
