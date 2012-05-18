class AnaindsController < ApplicationController
  def create
    @anagen = Anagen.find(params[:anaind][:anagen_id])
    @anaind = @anagen.anainds.build(params[:anaind])# La Build setta @anaind.anagen_id = @anagen.id
     
    if Anaind.nrmagexist(@anaind.id, @anaind.anagen_id, @anaind.nrmag)
      flash.now[:error] = "Indirizzo già esistente per il magazzino: #{@anaind.nrmag}"
      flash.keep
      render :action => :new
    else
      if @anaind.flmg == "S" and @anaind.nrmag == 0
        flash.now[:error] = "Magazzino di riferimento non specificato"
        flash.keep
        @anaind.nrmag = 1
        render :action => :new
      else 
        if @anaind.save
          redirect_to @anagen, :notice => 'Indirizzo anagrafico aggiunto con successo.'
        else
          flash.now[:error] = "ERRORE !!! durante il salvataggio dell'indirizzo anagrafico"
          render :action => :new
        end
      end
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
    if Anaind.nrmagexist(params[:id], anaind[:anagen_id], anaind[:nrmag])
      flash.now[:error] = "Indirizzo già esistente per il magazzino: #{anaind[:nrmag]}"
      flash.keep
      render :action => :edit
    else
      if anaind[:flmg] == "S" and anaind[:nrmag] == 0
        flash.now[:error] = "Magazzino di riferimento non specificato"
        flash.keep
        render :action => :edit
      else 
        if @anaind.update_attributes(params[:anaind])
          redirect_to @anaind, :notice => 'Indirizzo anagrafico modificato con successo.'
        else
          flash.now[:error] = "ERRORE !!! durante il salvataggio dell'indirizzo anagrafico"
          render :action => :edit
        end
      end
    end
  end

  def destroy
    @anaind = Anaind.find(params[:id])
    @anaind.destroy
    redirect_to @anaind.anagen
  end
end
