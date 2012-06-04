class LocalitasController < ApplicationController
  def chg_des_paese
    @des_paese = params[:paese][:descriz]
    if @des_paese.empty? 
      @nr = -1
      @paeses = Paese.all
      @des_paese = ""
    else
      @nr, @paeses = Paese.findlike_des(params[:paese][:descriz])
      #@paeses = Paese.where("descriz like ?", "%" + @des_paese + "%")
      #@nr = @paeses.count
      if @nr == 1
        #@des_paese = @paeses.descriz
        #@id = @paeses.first.id
        @des_paese = @paeses.first.descriz
        @id = @paeses.id
      end
    end
    respond_to do |format|
      format.js
    end 
  end

  def chg_cmb_paese
    @id_paese = params[:localita][:paese_id]
    if @id_paese.nil? or @id_paese.empty? 
      @des_paese = ""
    else
      @des_paese = Paese.find(@id_paese).descriz
    end
    respond_to do |format|
      format.js
    end 
  end

  def index
    @localitas = Localita.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @localita = Localita.find(params[:id])
  end

  def new
    @localita = Localita.new
    @localita.paese = Paese.new
#    @paeses = Paese.all
  end

  def edit
    @localita = Localita.find(params[:id])
  end

  def create
    @localita = Localita.new(params[:localita])
    if @localita.save
      redirect_to @localita, :notice => 'Localita'' inserita con successo.'
    else
      flash[:error] = "Il salvataggio della localita' non e' andato a buon fine"
      render :action => "new"
    end
  end

  def update
    @localita = Localita.find(params[:id])
    if @localita.update_attributes(params[:localita])
      redirect_to @localita, :notice => 'Localita'' aggiornata con successo.'
    else
      flash[:error] = "Il salvataggio della localita' non e' andato a buon fine"
      render :action => "edit"
    end
  end

  def destroy
    @localita = Localita.find(params[:id])
    begin
      @localita.destroy
      flash[:notice] = "Cancellazione Eseguita"
    rescue
      flash[:error] = $!.message
    end
    redirect_to localitas_url
  end
end
