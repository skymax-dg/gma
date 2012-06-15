require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'

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

  def article_exit
    @prezzo = Article.find(params[:rigdoc][:article_id]).prezzo unless params[:rigdoc][:article_id].empty? 
    @descriz = Article.find(params[:rigdoc][:article_id]).descriz unless params[:rigdoc][:article_id].empty? 
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

  def create
    @tesdoc = Tesdoc.find(params[:rigdoc][:tesdoc_id])
    newprg = @tesdoc.lastprgrig + 1
    @rigdoc = @tesdoc.rigdocs.build(params[:rigdoc])
    @rigdoc.prgrig = newprg
    if @rigdoc.save
      redirect_to @tesdoc, :notice => 'Riga documento aggiunta con successo.'
    else
      flash[:error] = "Il salvataggio della riga non e' andato a buon fine"
      render 'new'
    end
  end

  def new
    @rigdoc = Tesdoc.find(params[:id]).rigdocs.build # La Build valorizza automaticamente il campo rigdoc.tesdoc_id
    @rigdoc.sconto = Tesdoc.find(params[:id]).sconto
    @rigdoc.qta = 1
  end

  def addrow_fromxls
    begin
      @errors = []
      @success = []
      Spreadsheet.open "rigdocXLS.xls" do |book|
        @tesdoc = Tesdoc.find(params[:id])
        begin
          @errors = Article.chk_art_xls(book, 0, 1, 0)
          raise "I seguenti articoli non sono presenti sulla banca dati" if @errors.count > 0
          @errors, @success = @tesdoc.rigdocbyxls(book, 0, 1, {:article_id_bycod => 0, :qta => 1, :prezzo => 2, :sconto => 3})
          if @errors.count == 0
            flash[:notice] = "CARICAMENTO COMPLETATO con SUCCESSO."
          else
            flash[:error] = "Si sono verificati ERRORI durante il caricamento (CARICAMENTO PARZIALE)"
          end
        rescue
          flash[:error] = $!.message
        end
      end
    rescue Exception => e
      flash[:error] = $!.message
      @errors << "File bloccato da un'altra applicazione o non trovato: " + e #$?.exitstatus
    end
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
