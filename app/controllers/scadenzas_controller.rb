class ScadenzasController < ApplicationController

  before_filter :authenticate

  def new
    @title = "Nuova Scadenza documento"
    @scadenza = Tesdoc.find(params[:id]).scadenzas.build # La Build valorizza automaticamente il campo scadenza.tesdoc_id
  end

  def create
    @tesdoc = Tesdoc.find(params[:scadenza][:tesdoc_id])
    @scadenza = @tesdoc.scadenzas.build(params[:scadenza])
    if @scadenza.save
      flash[:success] = "Scadenza documento aggiunta con successo."
      redirect_to :controller=>:tesdocs, :action=>:show, :id=>@scadenza.tesdoc_id, :tab=>:scad
      #redirect_to @tesdoc
    else
      @title = "Nuova Scadenza documento"
      flash.now[:alert] = "Il salvataggio non e' andato a buon fine"
      render 'new'
    end
  end

#  def show
#    @title = "Mostra scadenza"
#    @scadenza = Scadenza.find(params[:id])
#  end

  def edit
    @title = "Modifica Scadenza"
    @scadenza = Scadenza.find(params[:id])
  end

  def update
    @scadenza = Scadenza.find(params[:id])
    if @scadenza.update_attributes(params[:scadenza])
      flash[:success] = "Scadenza modificata con successo."
      redirect_to :controller=>:tesdocs, :action=>:show, :id=>@scadenza.tesdoc_id, :tab=>:scad
    else
      @title = "Modifica Scadenza"
      flash.now[:alert] = "Il salvataggio non e' andato a buon fine"
      render 'edit'
    end
  end

  def destroy
    @scadenza = Scadenza.find(params[:id])
    begin
      @scadenza.destroy
      flash[:success] = "Cancellazione Eseguita"
    rescue
      flash[:alert] = $!.message
    end
    redirect_to :controller=>:tesdocs, :action=>:show, :id=>@scadenza.tesdoc_id, :tab=>:scad
  end

  def filter
    #store_tipo_doc(params[:tipo_doc])
    #store_location
    @title = "Elenco Scadenze"
    if params[:filter_scadenzas]
      @conto_id=params[:filter_scadenzas][:conto]
      @causmag_id=params[:filter_scadenzas][:causmag]
      @dtini=params[:filter_scadenzas][:dadata].to_date
      @dtfin=params[:filter_scadenzas][:adata].to_date
      @tipo=params[:filter_scadenzas][:tipo]
      @stato=params[:filter_scadenzas][:stato]
      @scadenzas, nrrecord = Scadenza.filter(@conto_id, @causmag_id,
                                             @dtini, @dtfin,
                                             @tipo, @stato,
                                             current_user.azienda, current_annoese,
                                             params[:page])
      flash_cnt(nrrecord) if params[:page].nil?
    else
      @dtini = "#{Date.today.year}-#{Date.today.month}-01".to_date
      Date.today.month == 12 ? @dtfin = "#{Date.today.year}-#{Date.today.month}-31".to_date : @dtfin = "#{Date.today.year}-#{Date.today.month+1}-01".to_date - 1
    end
    @causmags = Causmag.find(:all, :conditions => ["azienda = :azd", {:azd => current_user.azienda}])
    @contos = Conto.find(:all, :conditions => ["azienda = :azd and annoese = :ae",
                                                {:azd => current_user.azienda, :ae=>current_annoese}])
    store_location
  end


end
