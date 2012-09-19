class CausmagsController < ApplicationController
before_filter :authenticate
  def index
    @title = "Elenco Causali di magazzino"
    @causmags = Causmag.azienda(current_user.azienda).paginate(:page     => params[:page], 
                                                               :per_page => 20, 
                                                               :order => [:tipo_doc, :descriz])
  end

  def show
    @title = "Mostra Causale di magazzino"
    @causmag = Causmag.find(params[:id])
  end

  def new
    @title = "Nuova Causale di magazzino"
    @causmag = Causmag.new
    @causmag.azienda = current_user.azienda
    @causmag.nrmagsrc = 0
    @causmag.nrmagdst = 0
  end

  def edit
    @title = "Modifica Causale di magazzino"
    @causmag = Causmag.find(params[:id])
  end

  def create
    @causmag = Causmag.new(params[:causmag])
    @title = "Nuova Causale di magazzino"
    if not compat_contabile(@causmag.contabile, @causmag.causale_id.nil?)
      flash[:alert] = "incoerenza fra 'causale contabile' e flag 'contabile'"
      render :action => "new"
    else    
      if @causmag.save
        flash[:success] = 'Causale di magazzino inserita con successo.'
        redirect_to @causmag
      else
#        flash[:alert] = "Il salvataggio della causale non e' andato a buon fine"
        render :action => "new"
      end
    end
  end

  def update
    @causmag = Causmag.find(params[:id])
    @title = "Modifica Causale di magazzino"
    if not compat_contabile(params[:causmag][:contabile], params[:causmag][:causale_id] == "")
      flash[:alert] = "ERRORE!!! Incoerenza fra 'causale contabile' e flag 'contabile'"
      render :action => "edit"
    else    
      if @causmag.update_attributes(params[:causmag])
        flash[:success] = 'Causale di magazzino aggiornata con successo.'
        redirect_to @causmag
      else
#        flash[:alert] = "Il salvataggio della causale non e' andato a buon fine"
        render :action => "edit"
      end
    end
  end

  def destroy
    @causmag = Causmag.find(params[:id])
    begin
      @causmag.destroy
      flash[:success] = "Cancellazione Eseguita"
    rescue
      flash[:alert] = $!.message
    end
    redirect_to @causmag
  end
end
