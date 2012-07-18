class IvasController < ApplicationController
  # GET /ivas
  # GET /ivas.json
  def index
    @ivas = Iva.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ivas }
    end
  end

  # GET /ivas/1
  # GET /ivas/1.json
  def show
    @iva = Iva.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @iva }
    end
  end

  # GET /ivas/new
  # GET /ivas/new.json
  def new
    @iva = Iva.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @iva }
    end
  end

  # GET /ivas/1/edit
  def edit
    @iva = Iva.find(params[:id])
  end

  # POST /ivas
  # POST /ivas.json
  def create
    @iva = Iva.new(params[:iva])

    respond_to do |format|
      if @iva.save
        format.html { redirect_to @iva, notice: 'Iva was successfully created.' }
        format.json { render json: @iva, status: :created, location: @iva }
      else
        format.html { render action: "new" }
        format.json { render json: @iva.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ivas/1
  # PUT /ivas/1.json
  def update
    @iva = Iva.find(params[:id])

    respond_to do |format|
      if @iva.update_attributes(params[:iva])
        format.html { redirect_to @iva, notice: 'Iva was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @iva.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ivas/1
  # DELETE /ivas/1.json
  def destroy
    @iva = Iva.find(params[:id])
    @iva.destroy

    respond_to do |format|
      format.html { redirect_to ivas_url }
      format.json { head :no_content }
    end
  end
end
