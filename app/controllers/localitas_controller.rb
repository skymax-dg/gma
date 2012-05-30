class LocalitasController < ApplicationController
  def ges_paese
    @des_paese = params[:paese][:descriz]
    @cnt = -1
    if @des_paese.nil? or @des_paese.empty? 
      @paeses = Paese.all
      @des_paese = ""
    else
      @paeses = Paese.where("descriz like ?", "%" + @des_paese + "%")
      @cnt = @paeses.count
      if @cnt == 1
        @des_paese = @paeses.first.descriz
      end
    end
    respond_to do |format|
      format.js
    end 
  end

  def cbb_paese
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
@paeses = Paese.all
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
    @localita.destroy
    flash[:notice] = "Cancellazione Eseguita"
    redirect_to localitas_url
  end
end
