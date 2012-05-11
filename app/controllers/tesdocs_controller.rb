class TesdocsController < ApplicationController

  def filter
    @tesdocs = Tesdoc.filter(params[:tpfilter], params[:desfilter],
                             [params[:clifilter], params[:forfilter], params[:altfilter]],params[:page])
    render "index"
  end

  def index
    @tesdocs = Tesdoc.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @tesdocs }
    end
  end

  def show
    @tesdoc = Tesdoc.find(params[:id])
@rigdocs = @tesdoc.rigdocs.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @tesdoc }
    end
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

    respond_to do |format|
      if @tesdoc.save
        format.html { redirect_to @tesdoc, :notice => 'Tesdoc was successfully created.' }
        format.json { render :json => @tesdoc, :status => :created, :location => @tesdoc }
      else
        format.html { render :action => "new" }
        format.json { render :json => @tesdoc.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @tesdoc = Tesdoc.find(params[:id])

    respond_to do |format|
      if @tesdoc.update_attributes(params[:tesdoc])
        format.html { redirect_to @tesdoc, :notice => 'Tesdoc was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @tesdoc.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @tesdoc = Tesdoc.find(params[:id])
    @tesdoc.destroy

    respond_to do |format|
      format.html { redirect_to tesdocs_url }
      format.json { head :no_content }
    end
  end
end
