class MagsController < ApplicationController
  # GET /mags
  # GET /mags.json
  def index
    @mags = Mag.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @mags }
    end
  end

  # GET /mags/1
  # GET /mags/1.json
  def show
    @mag = Mag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @mag }
    end
  end

  # GET /mags/new
  # GET /mags/new.json
  def new
    @mag = Mag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @mag }
    end
  end

  # GET /mags/1/edit
  def edit
    @mag = Mag.find(params[:id])
  end

  # POST /mags
  # POST /mags.json
  def create
    @mag = Mag.new(params[:mag])

    respond_to do |format|
      if @mag.save
        format.html { redirect_to @mag, :notice => 'Mag was successfully created.' }
        format.json { render :json => @mag, :status => :created, :location => @mag }
      else
        format.html { render :action => "new" }
        format.json { render :json => @mag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /mags/1
  # PUT /mags/1.json
  def update
    @mag = Mag.find(params[:id])

    respond_to do |format|
      if @mag.update_attributes(params[:mag])
        format.html { redirect_to @mag, :notice => 'Mag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @mag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /mags/1
  # DELETE /mags/1.json
  def destroy
    @mag = Mag.find(params[:id])
    @mag.destroy

    respond_to do |format|
      format.html { redirect_to mags_url }
      format.json { head :no_content }
    end
  end
end
