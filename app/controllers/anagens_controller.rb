class AnagensController < ApplicationController
  # GET /anagens
  # GET /anagens.json
  def index
    @anagens = Anagen.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @anagens }
    end
  end

  # GET /anagens/1
  # GET /anagens/1.json
  def show
    @anagen = Anagen.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @anagen }
    end
  end

  # GET /anagens/new
  # GET /anagens/new.json
  def new
    @anagen = Anagen.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @anagen }
    end
  end

  # GET /anagens/1/edit
  def edit
    @anagen = Anagen.find(params[:id])
  end

  # POST /anagens
  # POST /anagens.json
  def create
    @anagen = Anagen.new(params[:anagen])

    respond_to do |format|
      if @anagen.save
        format.html { redirect_to @anagen, :notice => 'Anagen was successfully created.' }
        format.json { render :json => @anagen, :status => :created, :location => @anagen }
      else
        format.html { render :action => "new" }
        format.json { render :json => @anagen.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /anagens/1
  # PUT /anagens/1.json
  def update
    @anagen = Anagen.find(params[:id])

    respond_to do |format|
      if @anagen.update_attributes(params[:anagen])
        format.html { redirect_to @anagen, :notice => 'Anagen was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @anagen.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /anagens/1
  # DELETE /anagens/1.json
  def destroy
    @anagen = Anagen.find(params[:id])
    @anagen.destroy

    respond_to do |format|
      format.html { redirect_to anagens_url }
      format.json { head :no_content }
    end
  end
end
