class EventsController < ApplicationController
  before_filter :authenticate_request, if: :json_request?
  before_filter :authenticate

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
    @title = "Elenco eventi"

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @key_words_addable = KeyWord.sort_by_din(KeyWordEvent.all)
    @shipments   = @event.event_states.by_shipments
    @teachers    = @event.event_states.by_teachers
    @organizers  = @event.event_states.by_organizers
    @subscribers = @event.event_states.by_subscribers
    @anagens_addable = Anagen.order(:denomin)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new
    @title = "Inserimento evento"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @title = "Modifica evento"
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])
    notice = "Evento creato correttamente. "
    notice = "Codice sede non trovato." unless decode_site_anagen

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event.article, notice: notice }
        format.json { render json: @event.article, status: :created, location: @event.article }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])
    notice = "Evento aggiornato correttamente. "
    notice = "Codice sede non trovato." unless decode_site_anagen

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: notice }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to @event.article }
      format.json { head :no_content }
    end
  end

  private
    def decode_site_anagen
      if [nil,""].include? params[:site_anagen_code]
        true
      else
        tmp = Anagen.where(codice: params[:site_anagen_code]).first
        if tmp
          @event.site_anagen = tmp
        else
          false
        end
      end
    end
end
