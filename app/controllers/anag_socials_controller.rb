class AnagSocialsController < ApplicationController
  # GET /anag_socials
  # GET /anag_socials.json
  def index
    @anag_socials = AnagSocial.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @anag_socials }
    end
  end

  # GET /anag_socials/1
  # GET /anag_socials/1.json
  def show
    @anag_social = AnagSocial.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @anag_social }
    end
  end

  # GET /anag_socials/new
  # GET /anag_socials/new.json
  def new 
    @anag_social = AnagSocial.new
    @anagen = Anagen.find(params[:anagen_id])
    @title = "Nuovo collegamento social (#{@anagen.denomin})"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @anag_social }
    end
  end

  # GET /anag_socials/1/edit
  def edit
    @anag_social = AnagSocial.find(params[:id])
    @anagen = @anag_social.anagen
    @title = "Modifica collegamento social (#{@anagen.denomin})"
  end

  # POST /anag_socials
  # POST /anag_socials.json
  def create
    @anag_social = AnagSocial.new(params[:anag_social])

    respond_to do |format|
      if @anag_social.save
        format.html { redirect_to @anag_social.anagen, notice: 'AnagSocial was successfully created.' }
        format.json { render json: @anag_social, status: :created, location: @anag_social }
      else
        format.html { render action: "new" }
        format.json { render json: @anag_social.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /anag_socials/1
  # PUT /anag_socials/1.json
  def update
    @anag_social = AnagSocial.find(params[:id])

    respond_to do |format|
      if @anag_social.update_attributes(params[:anag_social])
        format.html { redirect_to @anag_social.anagen, notice: 'AnagSocial was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @anag_social.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anag_socials/1
  # DELETE /anag_socials/1.json
  def destroy
    @anag_social = AnagSocial.find(params[:id])
    @anag_social.destroy

    respond_to do |format|
      format.html { redirect_to @anag_social.anagen }
      format.json { head :no_content }
    end
  end
end
