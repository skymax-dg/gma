class CausmagsController < ApplicationController

  before_filter :authenticate
  before_filter :force_fieldcase, :only => [:create, :update]

  def index
    @title = "Elenco Causali di magazzino"
    flash_cnt(Causmag.count) if params[:page].nil?
    @causmags = Causmag.azienda(current_user.azienda).paginate(:page     => params[:page], 
                                                               :per_page => 10, 
                                                               :order => [:tipo_doc, :grp_prg, :movimpmag, :tipo, :descriz])
store_location
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
      flash.now[:alert] = "incoerenza fra 'causale contabile' e flag 'contabile'"
      render :action => "new"
    else    
      if @causmag.save
        flash[:success] = 'Causale di magazzino inserita con successo.'
        redirect_to @causmag
      else
#        flash.now[:alert] = "Il salvataggio della causale non e' andato a buon fine"
        render :action => "new"
      end
    end
  end

  def update
    @causmag = Causmag.find(params[:id])
    @title = "Modifica Causale di magazzino"
    if not compat_contabile(params[:causmag][:contabile], params[:causmag][:causale_id] == "")
      flash.now[:alert] = "ERRORE!!! Incoerenza fra 'causale contabile' e flag 'contabile'"
      render :action => "edit"
    else    
      if @causmag.update_attributes(params[:causmag])
        flash[:success] = 'Causale di magazzino aggiornata con successo.'
        redirect_to @causmag
      else
#        flash.now[:alert] = "Il salvataggio della causale non e' andato a buon fine"
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
redirect_back_or @causmag
  end

  private
    def force_fieldcase
      set_fieldcase(:causmag, [:modulo], [])
    end
end
