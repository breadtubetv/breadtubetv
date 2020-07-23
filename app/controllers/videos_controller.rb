class VideosController < ApplicationController
  before_action :set_channel, only: [:show, :edit, :update, :destroy]
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  # GET /videos
  # GET /videos.json
  def index
    @q = Video.published.latest.includes(:channel, :sources).ransack(params[:q])
    @videos = @q.result(distinct: true)
    @pagy, @videos = pagy(@videos, items: params[:items])
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    @videos = @channel.videos.random.limit(5)
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params)

    respond_to do |format|
      if @video.save
        format.html { redirect_to channel_video_path(@video.channel, @video), notice: 'Video was successfully created.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to channel_video_path(@video.channel, @video), notice: 'Video was successfully updated.' }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url, notice: 'Video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel
      @channel = Channel.friendly.find(params[:channel_id])
    end

    def set_video
      @video = @channel.videos.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def video_params
      params.require(:video).permit(:name, :slug, :description, :published_at, :channel_id)
    end
end
