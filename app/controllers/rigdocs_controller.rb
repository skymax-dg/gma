class RigdocsController < ApplicationController
  def create
    @tesdoc = Tesdoc.find(params[:rigdoc][:tesdoc_id]) 
    @rigdoc = @tesdoc.rigdocs.build(params[:rigdoc])
    @rigdoc.article_id = params[:article_id]
    if @rigdoc.save
      flash[:success] = "AGGIUNTA Riga documento!"
      redirect_to @tesdoc
    else
@feed_items = []
render 'pages/home'
    end
  end

  def destroy
    @rigdoc.destroy
    redirect_back_or root_path
  end

  def addrow
@a=5  
  end

  def new
    @rigdoc = Rigdoc.new
@a=1
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @rigdoc }
    end
  end

  def create2
    @rigdoc = Rigdoc.new(params[:rigdoc])
@a=2
    respond_to do |format|
      if @rigdoc.save
@a=3
        format.html { redirect_to @rigdoc, :notice => 'Rigdoc was successfully created.' }
        format.json { render :json => @rigdoc, :status => :created, :location => @rigdoc }
      else
@a=4
        format.html { render :action => "new" }
        format.json { render :json => @rigdoc.errors, :status => :unprocessable_entity }
      end
    end    
  end
end
