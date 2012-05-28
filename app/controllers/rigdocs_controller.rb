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
    #    render :text => "alert('Hello, world!')",
    #            :content_type => "text/javascript"
    respond_to do |format|
      format.js
    end
  end

  def get_idarticle1
    @idarticle = params[:articleid]
    respond_to do |format|
      format.js
    end
  end

  def get_idarticle2
    @idarticle = params[:articleid]
    respond_to do |format|
      format.js
    end
  end

  def create
    @tesdoc = Tesdoc.find(params[:rigdoc][:tesdoc_id])
    newprg = @tesdoc.rigdocs.last.prgrig + 1  
    @rigdoc = @tesdoc.rigdocs.build(params[:rigdoc])
    @rigdoc.prgrig = newprg
    if @rigdoc.save
      redirect_to @tesdoc, :notice => 'Riga documento aggiunta con successo.'
    else
      render :action => :new
    end
  end

  def new
    @rigdoc = Tesdoc.find(params[:id]).rigdocs.build # La Build valorizza automaticamente il campo rigdoc.tesdoc_id
    @rigdoc.sconto = Tesdoc.find(params[:id]).sconto
  end

  def show
    @rigdoc = Rigdoc.find(params[:id])
  end

  def edit
    @rigdoc = Rigdoc.find(params[:id])
@foo = "italia"
  end

  def update
    @rigdoc = Rigdoc.find(params[:id])
    if @rigdoc.update_attributes(params[:rigdoc])
      redirect_to @rigdoc, :notice => 'Testata documento modificata con successo.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @rigdoc = Rigdoc.find(params[:id])
    @rigdoc.destroy
    redirect_to @rigdoc.tesdoc
  end
end
