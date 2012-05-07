class ContosController < ApplicationController
  # GET /contos
  # GET /contos.json
  def index
    @contos = Conto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @contos }
    end
  end

  # GET /contos/1
  # GET /contos/1.json
  def show
    @conto = Conto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @conto }
    end
  end

  # GET /contos/new
  # GET /contos/new.json
  def new
    @conto = Conto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @conto }
    end
  end

  # GET /contos/1/edit
  def edit
    @conto = Conto.find(params[:id])
  end

  # POST /contos
  # POST /contos.json
  def create
    @conto = Conto.new(params[:conto])

    respond_to do |format|
      if @conto.save
        format.html { redirect_to @conto, :notice => 'Conto was successfully created.' }
        format.json { render :json => @conto, :status => :created, :location => @conto }
      else
        format.html { render :action => "new" }
        format.json { render :json => @conto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contos/1
  # PUT /contos/1.json
  def update
    @conto = Conto.find(params[:id])

    respond_to do |format|
      if @conto.update_attributes(params[:conto])
        format.html { redirect_to @conto, :notice => 'Conto was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @conto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contos/1
  # DELETE /contos/1.json
  def destroy
    @conto = Conto.find(params[:id])
    @conto.destroy

    respond_to do |format|
      format.html { redirect_to contos_url }
      format.json { head :no_content }
    end
  end
end
