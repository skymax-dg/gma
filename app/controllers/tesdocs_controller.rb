class TesdocsController < ApplicationController
  def index
    store_tipo_doc(params[:tipo_doc])
    init_filter()
  end

  def filter
    @tpfilter  = params[:tpfilter]
    @desfilter = params[:desfilter].strip
    @clifilter = params[:clifilter]
    @forfilter = params[:forfilter]
    @altfilter = params[:altfilter]
    @causmagfilter = params[:causmagfilter]
    @contofilter = params[:contofilter]
    @causmags = Causmag.find(:all, :conditions => ["tipo_doc = :tpd", {:tpd => se_tipo_doc}])
    @contos = Conto.find4docfilter([@clifilter, @forfilter, @altfilter], @tpfilter||"", @desfilter||"")
    @tesdocs = Tesdoc.filter(@tpfilter, @desfilter,
                             [@clifilter, @forfilter, @altfilter],
                             se_tipo_doc,
                             @causmagfilter,
                             @contofilter,
                             params[:page])
    render "index"
  end
  
  def new
    respond_to do |format|
      format.html do
        if params[:causmag].empty? or params[:causmag].nil? or params[:conto].empty? or params[:conto].nil?
          flash[:success] = "Per creare un nuovo DOC e' necessario prima impostare Causale e MastroContabile nei filtri e cliccare il bottone FILTRA"
          init_filter
          render "index"
        else
          @tesdoc = Tesdoc.new
          @causmag = Causmag.find(params[:causmag])
          @conto = Conto.find(params[:conto])
          @tesdoc.azienda = StaticData::AZIENDA
          @tesdoc.annoese = StaticData::ANNOESE
          @tesdoc.causmag_id = @causmag.id
          @tesdoc.conto_id = @conto.id
          @tesdoc.sconto = @conto.sconto
        end
      end
      format.js
    end
  #render "new"
  end

  def choose_tipo_doc
    clear_tipo_doc
  end

  def show
    @tesdoc = Tesdoc.find(params[:id])
    @rigdocs = @tesdoc.rigdocs.paginate(:page => params[:page], :per_page => 2)
    @rigdocs = @rigdocs.sort {|a,b|a.prgrig<=>b.prgrig}
  end

  def edit
    @tesdoc = Tesdoc.find(params[:id])
    @causmag = Causmag.find(@tesdoc.causmag_id)
    @conto = Conto.find(@tesdoc.conto_id)
  end

  def create
    @tesdoc = Tesdoc.new(params[:tesdoc])
    if @tesdoc.save
      redirect_to @tesdoc, :notice => 'Tesdoc was successfully created.'
    else
      @causmag = Causmag.find(params[:tesdoc][:causmag_id])
      @conto = Conto.find(params[:tesdoc][:conto_id])
      @tesdoc.azienda = StaticData::AZIENDA
      @tesdoc.annoese = StaticData::ANNOESE
      @tesdoc.causmag_id = @causmag.id
      @tesdoc.conto_id = @conto.id
      @tesdoc.sconto = @conto.sconto
      render :action => "new"
    end
  end

  def update
    @tesdoc = Tesdoc.find(params[:id])
    if @tesdoc.update_attributes(params[:tesdoc])
      redirect_to @tesdoc, :notice => 'Tesdoc was successfully updated.'
    else
      render :action => "edit" 
    end
  end

  def destroy
    @tesdoc = Tesdoc.find(params[:id])
    @tesdoc.destroy
    redirect_to tesdocs_url
  end
end
