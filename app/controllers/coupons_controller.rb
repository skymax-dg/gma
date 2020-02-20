class CouponsController < ApplicationController
  # GET /coupons
  # GET /coupons.json
  def index
    @state = params[:state] ? params[:state].to_i : 1
    if @state == 2
      @coupons = Coupon.discount_codes.paginate(:page => params[:page])
      @title = "Lista codici sconto"
    else
      @coupons = Coupon.not_discount_codes.generic.paginate(:page => params[:page])
      @title = "Lista coupon generici"
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupons }
    end
  end

  # GET /coupons/1
  # GET /coupons/1.json
  def show
    @coupon = Coupon.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @coupon }
    end
  end

  # GET /coupons/new
  # GET /coupons/new.json
  def new 
    @title = "Nuovo coupon"
    @coupon = Coupon.new
    @anagen = Anagen.find(params[:anagen_id]) if params[:anagen_id] 
    @state = params[:state] ? params[:state].to_i : 1

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @coupon }
    end
  end

  # GET /coupons/1/edit
  def edit
    @title = "Modifica coupon"
    @coupon = Coupon.find(params[:id])
    @anagen = @coupon.anagen
    @state = @coupon.state
  end

  # POST /coupons
  # POST /coupons.json
  def create
    st = decode_article
    unless st
      redirect_to :back, notice: "Errore. Codice articolo non valido."
      return
    end
    @coupon = Coupon.new(params[:coupon])

    respond_to do |format|
      if @coupon.save
        format.html { redirect_to @coupon.anagen || coupons_path(state: @coupon.state), notice: 'Coupon was successfully created.' }
        format.json { render json: @coupon, status: :created, location: @coupon }
      else
        format.html { render action: "new" }
        format.json { render json: @coupon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /coupons/1
  # PUT /coupons/1.json
  def update
    st = decode_article
    unless st
      redirect_to :back, notice: "Errore. Codice articolo non valido."
      return
    end
    @coupon = Coupon.find(params[:id])

    respond_to do |format|
      if @coupon.update_attributes(params[:coupon])
        format.html { redirect_to @coupon.anagen || coupons_path(state: @coupon.state), notice: 'Coupon was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @coupon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coupons/1
  # DELETE /coupons/1.json
  def destroy
    @coupon = Coupon.find(params[:id])
    @coupon.destroy

    respond_to do |format|
      format.html { redirect_to @coupon.anagen || coupons_path }
      format.json { head :no_content }
    end
  end

  def activate_discount
    code = params[:code]
    anag_id = params[:anag_id]

    ris = Anagen.activate_discount_code(anag_id, code)
    render json: { status: ris != 0, result: ris}
  end

  private
    def decode_article
      if params[:coupon] && params[:article_code] && params[:article_code] != ""
        if Article.exists?(codice: params[:article_code])
          params[:coupon][:article_id] = Article.where(codice: params[:article_code]).first.id
          true
        else
          false
        end
      else
        true
      end
    end
end
