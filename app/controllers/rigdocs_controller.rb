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

  def addrow_fromxls
    Spreadsheet.open "rigdocXLS.xls" do |book|
      @tesdoc = Tesdoc.find(params[:id])

      @errors = []
      book.worksheet(0).each 1 do |row|
        unless row[0].blank?
          if not Article.find_by_codice(row[0].to_s.strip)
            @errors << "L'articolo con codice: " + row[0].to_s.strip + " riportato sulla riga: " + (row.idx + 1).to_s + " non e' presente in banca dati."
          end
        end
      end
      if @errors.count > 0
#        @rigdoc = @tesdoc.rigdocs.build
      else
        prgrig = 1
        prgrig = @tesdoc.rigdocs.last.prgrig + 1 unless @tesdoc.rigdocs.empty?   
        book.worksheet(0).each 1 do |row|
          unless row[0].blank?
            @rigdoc = @tesdoc.rigdocs.build # La Build valorizza automaticamente il campo rigdoc.tesdoc_id

            @rigdoc.article_id = Article.find_by_codice(row[0].to_s.strip).id
            @rigdoc.descriz = Article.find_by_codice(row[0].to_s.strip).descriz
            @rigdoc.qta = row[2]
            @rigdoc.prezzo = row[3]
            @rigdoc.sconto = row[4]
            @rigdoc.prgrig = prgrig

            if @rigdoc.save
              prgrig += 1
    #            redirect_to @tesdoc, :notice => 'Riga documento aggiunta con successo.'
            else
    #            flash[:error] = "Il salvataggio della riga non e' andato a buon fine"
    #            render :action => :new
            end
          end
        end
#        redirect_to :controller => 'tesdoc', :action => "show"
        redirect_to @tesdoc
      end
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
