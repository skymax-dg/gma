class RigdocsController < ApplicationController
  def create
    @tesdoc = Tesdoc.find(params[:rigdoc][:tesdoc_id]) 
    @rigdoc = @tesdoc.rigdocs.build(params[:rigdoc])
    #@rigdoc.article_id = params[:article_id]
    if @rigdoc.save
      flash[:success] = "AGGIUNTA Riga documento!"
      redirect_to @tesdoc
    else
      flash[:error] = "ERRORE !!! Salvatatggio riga non riuscito"
      redirect_to @tesdoc
    end
  end

  def show
    @rigdoc = Rigdoc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @tesdoc }
    end
  end

  def edit
    @rigdoc = Rigdoc.find(params[:id])
  end

  def update
    @rigdoc = Rigdoc.find(params[:id])

    respond_to do |format|
      if @rigdoc.update_attributes(params[:rigdoc])
        format.html { redirect_to @rigdoc, :notice => 'Tesdoc was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @tesdoc.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @rigdoc = Rigdoc.find(params[:id])
    @rigdoc.destroy

    respond_to do |format|
      format.html { redirect_to @rigdoc.tesdoc }
      format.json { head :no_content }
    end
  end

end
