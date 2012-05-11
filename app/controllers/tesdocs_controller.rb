class TesdocsController < ApplicationController
  def filter
    @tesdocs = Tesdoc.filter(params[:tpfilter], params[:desfilter],
                             [params[:clifilter], params[:forfilter], params[:altfilter]],params[:page])
    render "index"
  end

  def index
    @tesdocs = Tesdoc.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @tesdoc = Tesdoc.find(params[:id])
@rigdocs = @tesdoc.rigdocs.paginate(:page => params[:page], :per_page => 2)
@rigdocs = @rigdocs.sort {|a,b|a.prgrig<=>b.prgrig}
  end

  def new
    @tesdoc = Tesdoc.new
  end

  def addrow
    @rigdoc = Tesdoc.find(params[:id]).rigdocs.build # La Build valorizza automaticamente il campo rigdoc.tesdoc_id 
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
