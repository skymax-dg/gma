class CausmagsController < ApplicationController
  # GET /causmags
  # GET /causmags.json
  def index
    @causmags = Causmag.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @causmags }
    end
  end

  # GET /causmags/1
  # GET /causmags/1.json
  def show
    @causmag = Causmag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @causmag }
    end
  end

  # GET /causmags/new
  # GET /causmags/new.json
  def new
    @causmag = Causmag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @causmag }
    end
  end

  # GET /causmags/1/edit
  def edit
    @causmag = Causmag.find(params[:id])
  end

  # POST /causmags
  # POST /causmags.json
  def create
    @causmag = Causmag.new(params[:causmag])
    respond_to do |format|
      if @causmag.save
        format.html { redirect_to @causmag, :notice => 'Causmag was successfully created.' }
        format.json { render :json => @causmag, :status => :created, :location => @causmag }
      else
        format.html { render :action => "new" }
        format.json { render :json => @causmag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /causmags/1
  # PUT /causmags/1.json
  def update
    @causmag = Causmag.find(params[:id])
    respond_to do |format|
      if @causmag.update_attributes(params[:causmag])
        format.html { redirect_to @causmag, :notice => 'Causmag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @causmag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /causmags/1
  # DELETE /causmags/1.json
  def destroy
    @causmag = Causmag.find(params[:id])
    @causmag.destroy

    respond_to do |format|
      format.html { redirect_to causmags_url }
      format.json { head :no_content }
    end
  end
end
