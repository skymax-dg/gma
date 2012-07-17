class SpedizsController < ApplicationController
  def setind
    @anaind = Anaind.find(params[:spediz][:anaind_id])
    @des1 = @anaind.indir.strip
    @des2 = "#{@anaind.cap} #{@anaind.desloc}".strip
  end

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
    @spediz = Tesdoc.find(params[:id]).build_spediz # La Build valorizza automaticamente il campo spediz.tesdoc_id
    #@spediz = Spediz.new
    #@spediz.tesdoc_id = params[:id]
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @spediz }
    end
  end

  # GET /spedizs/1/edit
  def edit
    @spediz = Tesdoc.find(params[:id]).spediz
  end

  # POST /spedizs
  # POST /spedizs.json
  def create
    @spediz = Tesdoc.find(params[:spediz][:tesdoc_id]).build_spediz(params[:spediz])
    if @spediz.save
      redirect_to @spediz.tesdoc, :notice => 'Dati spedizione inseriti con successo.'
    else
      flash[:error] = "Il salvataggio dei dati spedizione non e' andato a buon fine"
      render 'new'
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
