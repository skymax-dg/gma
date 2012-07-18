class PrezzoarticclisController < ApplicationController
  # GET /prezzoarticclis
  # GET /prezzoarticclis.json
  def index
    @prezzoarticclis = Prezzoarticcli.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @prezzoarticclis }
    end
  end

  # GET /prezzoarticclis/1
  # GET /prezzoarticclis/1.json
  def show
    @prezzoarticcli = Prezzoarticcli.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @prezzoarticcli }
    end
  end

  # GET /prezzoarticclis/new
  # GET /prezzoarticclis/new.json
  def new
    @prezzoarticcli = Prezzoarticcli.new
    @prezzoarticcli.prezzo = 0.00
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @prezzoarticcli }
    end
  end

  # GET /prezzoarticclis/1/edit
  def edit
    @prezzoarticcli = Prezzoarticcli.find(params[:id])
  end

  # POST /prezzoarticclis
  # POST /prezzoarticclis.json
  def create
    @prezzoarticcli = Prezzoarticcli.new(params[:prezzoarticcli])
    respond_to do |format|
      if @prezzoarticcli.save
        format.html { redirect_to @prezzoarticcli, :notice => 'Prezzoarticcli was successfully created.' }
        format.json { render :json => @prezzoarticcli, :status => :created, :location => @prezzoarticcli }
      else
        format.html { render :action => "new" }
        format.json { render :json => @prezzoarticcli.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /prezzoarticclis/1
  # PUT /prezzoarticclis/1.json
  def update
    @prezzoarticcli = Prezzoarticcli.find(params[:id])
    respond_to do |format|
      if @prezzoarticcli.update_attributes(params[:prezzoarticcli])
        format.html { redirect_to @prezzoarticcli, :notice => 'Prezzoarticcli was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @prezzoarticcli.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /prezzoarticclis/1
  # DELETE /prezzoarticclis/1.json
  def destroy
    @prezzoarticcli = Prezzoarticcli.find(params[:id])
    @prezzoarticcli.destroy

    respond_to do |format|
      format.html { redirect_to prezzoarticclis_url }
      format.json { head :no_content }
    end
  end
end
