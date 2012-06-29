class SpedizsController < ApplicationController
  # GET /spedizs
  # GET /spedizs.json
  def index
    @spedizs = Spediz.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @spedizs }
    end
  end

  # GET /spedizs/1
  # GET /spedizs/1.json
  def show
    @spediz = Spediz.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @spediz }
    end
  end

  # GET /spedizs/new
  # GET /spedizs/new.json
  def new
    @spediz = Spediz.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @spediz }
    end
  end

  # GET /spedizs/1/edit
  def edit
    @spediz = Spediz.find(params[:id])
  end

  # POST /spedizs
  # POST /spedizs.json
  def create
    @spediz = Spediz.new(params[:spediz])

    respond_to do |format|
      if @spediz.save
        format.html { redirect_to @spediz, :notice => 'Spediz was successfully created.' }
        format.json { render :json => @spediz, :status => :created, :location => @spediz }
      else
        format.html { render :action => "new" }
        format.json { render :json => @spediz.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /spedizs/1
  # PUT /spedizs/1.json
  def update
    @spediz = Spediz.find(params[:id])

    respond_to do |format|
      if @spediz.update_attributes(params[:spediz])
        format.html { redirect_to @spediz, :notice => 'Spediz was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @spediz.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /spedizs/1
  # DELETE /spedizs/1.json
  def destroy
    @spediz = Spediz.find(params[:id])
    @spediz.destroy

    respond_to do |format|
      format.html { redirect_to spedizs_url }
      format.json { head :no_content }
    end
  end
end
