class AnaindsController < ApplicationController

  before_filter :authenticate
  before_filter :force_fieldcase, :only => [:create, :update]

  def create
    @anagen = Anagen.find(params[:anaind][:anagen_id])
    @anaind = @anagen.anainds.build(params[:anaind])# La Build setta @anaind.anagen_id = @anagen.id
    @title = "Nuovo Indirizzo"
    if Anaind.nrmagexist(@anaind.id, @anaind.anagen_id, @anaind.nrmag)
      flash.now[:alert] = "Indirizzo gia' esistente per il magazzino: #{@anaind.nrmag}"
      render :action => :new
      elsif not compat_mag(@anaind.flmg, @anaind.nrmag)
        flash.now[:alert] = "Magazzino di riferimento incompatibile con il check: Indirizzo di magazzino"
        render :action => :new
        elsif @anaind.save
          flash[:success] = 'Indirizzo anagrafico aggiunto con successo.'
          redirect_to @anagen
        else
#          flash.now[:alert] = "ERRORE !!! durante il salvataggio dell'indirizzo anagrafico"
          render :action => :new
    end
  end

  def descrizloc
    loc_id = params[:anaind][:localita_id]
    if loc_id.nil? or loc_id.empty? 
    else
      loc = Localita.find(loc_id)
      @descrizloc = ""
      @descrizloc = "#{loc.cap}, " unless loc.cap.empty?
      @descrizloc = "#{@descrizloc}#{loc.descriz}"
      @descrizloc = "#{@descrizloc} (#{loc.prov})" unless loc.prov.empty?
      @descrizloc = "#{@descrizloc} - #{loc.paese.descriz}" unless loc.paese.nil?
      @caploc = loc.cap unless loc.cap.empty?
    end 
    respond_to do |format|
      format.js
    end
  end

  def reset_locid
    respond_to do |format|
      format.js
    end
  end

  def new
    @title = "Nuovo Indirizzo"
    @anaind = Anagen.find(params[:id]).anainds.build # La Build valorizza automaticamente il campo anaind.anagen_id
    @anaind.flsl = 'N'
    @anaind.flsp = 'N'
    @anaind.flmg = 'N'
    @anaind.nrmag = 0
  end

  def show
    @title = "Mostra Indirizzo"
    @anaind = Anaind.find(params[:id])
  end

  def edit
    @title = "Modifica Indirizzo"
    @anaind = Anaind.find(params[:id])
  end

  def update
    @anaind = Anaind.find(params[:id])
    anaind = params[:anaind]
    @title = "Modifica Indirizzo"
    if Anaind.nrmagexist(params[:id].to_i, anaind[:anagen_id].to_i, anaind[:nrmag].to_i)
      flash.now[:alert] = "Indirizzo gia' esistente per il magazzino: #{anaind[:nrmag]}"
      render :action => :edit
      elsif not compat_mag(anaind[:flmg],  anaind[:nrmag].to_i)
        flash.now[:alert] = "Magazzino di riferimento incompatibile con il check: Indirizzo di magazzino"
        render :action => :edit
        elsif @anaind.update_attributes(params[:anaind])
          flash[:success] = 'Indirizzo anagrafico modificato con successo.'
          redirect_to @anaind
        else
#         flash.now[:alert] = "ERRORE !!! durante il salvataggio dell'indirizzo anagrafico"
         render :action => :edit
    end
  end

  def destroy
    @anaind = Anaind.find(params[:id])
    begin
      @anaind.destroy
      flash[:success] = "Cancellazione Eseguita"
    rescue
      flash[:alert] = $!.message
    end
    redirect_to @anaind.anagen
  end

  private
    def force_fieldcase
      set_fieldcase(:anaind, [:desloc, :cap], [])
    end
end
