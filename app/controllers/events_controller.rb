class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy]
  before_action :authenticate_token

  # GET /events
  def index
    @events = Event.all

    render json: @events
  end

  # GET /events/1
  def show
    if @is_authenticated
      render json: @event
    end
  end

  # POST /events
  def create
    if @is_authenticated
      @event = Event.new(event_params)

      if @event.save
        render json: @event, status: :created, location: @event
      else
        render json: @event.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /events/1
  def update
    if @is_authenticated
      if @event.update(event_params)
        render json: @event
      else
        render json: @event.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /events/1
  def destroy
    if @is_authenticated
      @event.destroy
    end
  end

  private
    #This is to authenticate that the call is set from an account of the front-end
    def authenticate_token
      @is_authenticated = false
      if request.headers["TOKEN"]
        if request.headers["TOKEN"] == "AppDipre"
          @is_authenticated = true
        end
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:title, :description, :epigraph, :date)
    end
end
