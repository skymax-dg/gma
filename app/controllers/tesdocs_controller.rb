class TesdocsController < ApplicationController
  def updmag
    dsds
  end

  def filter
    @tipo_doc  = params[:tipo_doc].to_i
    @tpfilter  = params[:tpfilter]
    @desfilter = params[:desfilter]
    @clifilter = params[:clifilter]
    @forfilter = params[:forfilter]
    @altfilter = params[:altfilter]
    @causmagfilter = params[:causmagfilter]
    @causmags = Causmag.find(:all, :conditions => ["tipo_doc = :tpd", {:tpd => @tipo_doc}])
    @tesdocs = Tesdoc.filter(@tpfilter, @desfilter,
                             [@clifilter, @forfilter, @altfilter],
                             @tipo_doc,
                             @causmagfilter,
                             params[:page])
    render "index"
  end

  def index
    @tesdocs = Tesdoc.paginate(:page => params[:page], :per_page => 10)
  end

  def choose_tipo_doc
  end

  def show
    @tesdoc = Tesdoc.find(params[:id])
@rigdocs = @tesdoc.rigdocs.paginate(:page => params[:page], :per_page => 2)
@rigdocs = @rigdocs.sort {|a,b|a.prgrig<=>b.prgrig}
  end

  def new
    @tesdoc = Tesdoc.new
    @tesdoc.azienda = StaticData::AZIENDA
    @tesdoc.annoese = StaticData::ANNOESE
  end

  def edit
    @tesdoc = Tesdoc.find(params[:id])
  end

  def create
    @tesdoc = Tesdoc.new(params[:tesdoc])
    if @tesdoc.save
      redirect_to @tesdoc, :notice => 'Tesdoc was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
  dfd
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
