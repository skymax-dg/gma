class TesdocsController < ApplicationController
  # GET /tesdocs
  # GET /tesdocs.json
  def index
    @tesdocs = Tesdoc.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @tesdocs }
    end
  end

  # GET /tesdocs/1
  # GET /tesdocs/1.json
  def show
    @tesdoc = Tesdoc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @tesdoc }
    end
  end

  # GET /tesdocs/new
  # GET /tesdocs/new.json
  def new
    @tesdoc = Tesdoc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @tesdoc }
    end
  end

  # GET /tesdocs/addrow
  # GET /tesdocs/addrow.json
  def addrow
    @tesdoc = Tesdoc.find(params[:id])
    @rigdoc = @tesdoc.rigdocs.build
    @rigdoc.tesdoc_id = @tesdoc.id 
#    @article= Article.new
#    @rigdoc = Rigdoc.new

  end

  # GET /tesdocs/1/edit
  def edit
    @tesdoc = Tesdoc.find(params[:id])
  end

  # POST /tesdocs
  # POST /tesdocs.json
  def create
    @tesdoc = Tesdoc.new(params[:tesdoc])

    respond_to do |format|
      if @tesdoc.save
        format.html { redirect_to @tesdoc, :notice => 'Tesdoc was successfully created.' }
        format.json { render :json => @tesdoc, :status => :created, :location => @tesdoc }
      else
        format.html { render :action => "new" }
        format.json { render :json => @tesdoc.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tesdocs/1
  # PUT /tesdocs/1.json
  def update
    @tesdoc = Tesdoc.find(params[:id])

    respond_to do |format|
      if @tesdoc.update_attributes(params[:tesdoc])
        format.html { redirect_to @tesdoc, :notice => 'Tesdoc was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @tesdoc.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tesdocs/1
  # DELETE /tesdocs/1.json
  def destroy
    @tesdoc = Tesdoc.find(params[:id])
#    @tesdoc.destroy

    respond_to do |format|
      format.html { redirect_to tesdocs_url }
      format.json { head :no_content }
    end
  end
end
