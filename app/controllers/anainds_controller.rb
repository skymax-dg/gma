class AnaindsController < ApplicationController
  def create
    @anagen = Anagen.find(params[:anaind][:anagen_id])
    @anaind = @anagen.anainds.build(params[:anaind])# La Build setta @anaind.anagen_id = @anagen.id
    if Anaind.nrmagexist(@anaind.id, @anaind.anagen_id, @anaind.nrmag)
      flash.now[:error] = "Indirizzo già esistente per il magazzino: #{@anaind.nrmag}"
      render :action => :new
      elsif (@anaind.flmg == "S" and @anaind.nrmag == 0) or
            (@anaind.flmg == "N" and @anaind.nrmag > 0)
        flash.now[:error] = "Magazzino di riferimento incompatibile con il check: Indirizzo di magazzino"
        flash.keep
        render :action => :new
        elsif @anaind.save
          redirect_to @anagen, :notice => 'Indirizzo anagrafico aggiunto con successo.'
        else
          flash.now[:error] = "ERRORE !!! durante il salvataggio dell'indirizzo anagrafico"
          render :action => :new
    end
  end

  def descrizloc
    @descrizloc = Localita.find(params[:anaind][:localita_id]).descriz unless params[:anaind][:localita_id].empty? 
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
      flash.now[:error] = "Indirizzo già esistente per il magazzino: #{anaind[:nrmag]}"
      flash.keep
      render :action => :edit
      elsif (anaind[:flmg] == "S" and anaind[:nrmag] == "0") or
            (anaind[:flmg] == "N" and anaind[:nrmag] > "0")
        flash.now[:error] = "Magazzino di riferimento incompatibile con il check: Indirizzo di magazzino"
        flash.keep
        render :action => :edit
        elsif @anaind.update_attributes(params[:anaind])
         redirect_to @anaind, :notice => 'Indirizzo anagrafico modificato con successo.'
        else
         flash.now[:error] = "ERRORE !!! durante il salvataggio dell'indirizzo anagrafico"
         render :action => :edit
    end
  end

  def destroy
    @anaind = Anaind.find(params[:id])
    begin
      @anaind.destroy
    rescue
      flash[:notice] = $!.message
    end
    redirect_to @anaind.anagen
  end
end
