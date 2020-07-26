class ChannelsController < ApplicationController
  before_action :set_channel, only: [:edit, :sync, :update, :destroy]
  before_action :set_channel_and_videos, only: [:show]

  # GET /channels
  # GET /channels.json
  def index
    @q = Channel.includes(:sources).order_by_slug.ransack(params[:q])
    @channels = @q.result(distinct: true)
    @pagy, @channels = pagy(@channels, items: params[:items])
  end

  # GET /channels/1
  # GET /channels/1.json
  def show
  end

  # GET /channels/new
  def new
    @channel = Channel.new
  end

  # GET /channels/1/edit
  def edit
  end

  # GET /channels/1/sync
  def sync
    @channel.sync!

    redirect_to channel_path(@channel)
  end

  # POST /channels
  # POST /channels.json
  def create
    @channel = Channel.new(channel_params)

    respond_to do |format|
      if @channel.save
        format.html { redirect_to @channel, notice: 'Channel was successfully created.' }
        format.json { render :show, status: :created, location: @channel }
      else
        format.html { render :new }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /channels/1
  # PATCH/PUT /channels/1.json
  def update
    respond_to do |format|
      if @channel.update(channel_params)
        format.html { redirect_to @channel, notice: 'Channel was successfully updated.' }
        format.json { render :show, status: :ok, location: @channel }
      else
        format.html { render :edit }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channels/1
  # DELETE /channels/1.json
  def destroy
    @channel.destroy
    respond_to do |format|
      format.html { redirect_to channels_url, notice: 'Channel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel
      @channel = Channel.includes(:sources).friendly.find(params[:id])
    end

    def set_channel_and_videos
      @channel = Channel.includes(:sources, :supports, :socials, :videos).friendly.find(params[:id])
      @videos = @channel.videos.includes(:channel, :sources).published.latest
      @sources = @channel.sources.order_by_type
      @socials = @channel.socials.order_by_type
      @supports = @channel.supports.order_by_type
      @pagy, @videos = pagy(@videos, items: params[:items])
    end

    # Only allow a list of trusted parameters through.
    def channel_params
      params.require(:channel).permit(:name, :slug, :description, :image)
    end
end
