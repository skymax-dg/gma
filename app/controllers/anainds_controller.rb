class AnaindsController < ApplicationController
  def create
    @anagen = Anagen.find(params[:anaind][:anagen_id])
    @anaind = @anagen.anainds.build(params[:anaind])# La Build setta @anaind.anagen_id = @anagen.id
    if Anaind.nrmagexist(@anaind.id, @anaind.anagen_id, @anaind.nrmag)
      flash.now[:error] = "Indirizzo gia' esistente per il magazzino: #{@anaind.nrmag}"
      render :action => :new
      elsif (@anaind.flmg == "S" and @anaind.nrmag == 0) or
            (@anaind.flmg == "N" and @anaind.nrmag > 0)
        flash[:error] = "Magazzino di riferimento incompatibile con il check: Indirizzo di magazzino"
        render :action => :new
        elsif @anaind.save
          redirect_to @anagen, :notice => 'Indirizzo anagrafico aggiunto con successo.'
        else
          flash[:error] = "ERRORE !!! durante il salvataggio dell'indirizzo anagrafico"
          render :action => :new
    end
  end

  def descrizloc
    loc_id = params[:anaind][:localita_id]
    if loc_id.nil? or loc_id.empty? 
    else
      loc = Localita.find(loc_id)
      @descrizloc = ""
      @descrizloc = loc.cap + ", " unless loc.cap.empty?
      @descrizloc = @descrizloc + loc.descriz
      @descrizloc = @descrizloc + " (" + loc.prov + ")" unless loc.prov.empty?
      @descrizloc = @descrizloc + " - " + loc.paese.descriz unless loc.paese.nil?
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
    @anaind = Anagen.find(params[:id]).anainds.build # La Build valorizza automaticamente il campo anaind.anagen_id
    @anaind.flsl = 'N'
    @anaind.flsp = 'N'
    @anaind.flmg = 'N'
    @anaind.nrmag = 0
  end

  def show
    @anaind = Anaind.find(params[:id])
  end

  def edit
    @anaind = Anaind.find(params[:id])
  end

  def update
    @anaind = Anaind.find(params[:id])
    anaind = params[:anaind]
    if Anaind.nrmagexist(params[:id].to_i, anaind[:anagen_id].to_i, anaind[:nrmag].to_i)
      flash[:error] = "Indirizzo gia' esistente per il magazzino: #{anaind[:nrmag]}"
      render :action => :edit
      elsif (anaind[:flmg] == "S" and anaind[:nrmag] == "0") or
            (anaind[:flmg] == "N" and anaind[:nrmag] > "0")
        flash[:error] = "Magazzino di riferimento incompatibile con il check: Indirizzo di magazzino"
        render :action => :edit
        elsif @anaind.update_attributes(params[:anaind])
         redirect_to @anaind, :notice => 'Indirizzo anagrafico modificato con successo.'
        else
         flash[:error] = "ERRORE !!! durante il salvataggio dell'indirizzo anagrafico"
         render :action => :edit
    end
  end

  def destroy
    @anaind = Anaind.find(params[:id])
    begin
      @anaind.destroy
      flash[:notice] = "Cancellazione Eseguita"
    rescue
      flash[:error] = $!.message
    end
    redirect_to @anaind.anagen
  end
end
