class CausmagsController < ApplicationController
before_filter :authenticate
  def index
    @causmags = Causmag.azienda(current_user.azienda).paginate(:page     => params[:page], 
                                                               :per_page => 20, 
                                                               :order => [:tipo_doc, :descriz])
  end

  def show
    @causmag = Causmag.find(params[:id])
  end

  def new
    @causmag = Causmag.new
    @causmag.azienda = current_user.azienda
    @causmag.nrmagsrc = 0
    @causmag.nrmagdst = 0
  end

  def edit
    @causmag = Causmag.find(params[:id])
  end

  def create
    @causmag = Causmag.new(params[:causmag])
    if not compat_contabile(@causmag.contabile, @causmag.causale_id.nil?)
      flash[:error_explanation] = "incoerenza fra 'causale contabile' e flag 'contabile'"
      render :action => "new"
    else    
      if @causmag.save
        redirect_to @causmag, :notice => 'Causale di magazzino inserita con successo.'
      else
        flash[:error] = "Il salvataggio della causale non e' andato a buon fine"
        render :action => "new"
      end
    end
  end

  def update
    @causmag = Causmag.find(params[:id])
    if not compat_contabile(params[:causmag][:contabile], params[:causmag][:causale_id] == "")
      flash[:error_explanation] = "ERRORE!!! Incoerenza fra 'causale contabile' e flag 'contabile'"
      render :action => "edit"
    else    
      if @causmag.update_attributes(params[:causmag])
        redirect_to @causmag, :notice => 'Causale di magazzino aggiornata con successo.'
      else
        flash[:error] = "Il salvataggio della causale non e' andato a buon fine"
        render :action => "edit"
      end
    end
  end

  def destroy
    @causmag = Causmag.find(params[:id])
    begin
      @causmag.destroy
      flash[:notice] = "Cancellazione Eseguita"
    rescue
      flash[:error] = $!.message
    end
    redirect_to causmags_url
  end
end
