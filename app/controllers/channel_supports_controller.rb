class ChannelSupportsController < ApplicationController
  before_action :set_channel_support, only: [:show, :edit, :update, :destroy]

  # GET /channel_supports
  # GET /channel_supports.json
  def index
    @channel_supports = ChannelSupport.all
  end

  # GET /channel_supports/1
  # GET /channel_supports/1.json
  def show
  end

  # GET /channel_supports/new
  def new
    @channel_support = ChannelSupport.new
  end

  # GET /channel_supports/1/edit
  def edit
  end

  # POST /channel_supports
  # POST /channel_supports.json
  def create
    @channel_support = ChannelSupport.new(channel_support_params)

    respond_to do |format|
      if @channel_support.save
        format.html { redirect_to @channel_support, notice: 'Channel support was successfully created.' }
        format.json { render :show, status: :created, location: @channel_support }
      else
        format.html { render :new }
        format.json { render json: @channel_support.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /channel_supports/1
  # PATCH/PUT /channel_supports/1.json
  def update
    respond_to do |format|
      if @channel_support.update(channel_support_params)
        format.html { redirect_to @channel_support, notice: 'Channel support was successfully updated.' }
        format.json { render :show, status: :ok, location: @channel_support }
      else
        format.html { render :edit }
        format.json { render json: @channel_support.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channel_supports/1
  # DELETE /channel_supports/1.json
  def destroy
    @channel_support.destroy
    respond_to do |format|
      format.html { redirect_to channel_supports_url, notice: 'Channel support was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel_support
      @channel_support = ChannelSupport.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def channel_support_params
      params.require(:channel_support).permit(:channel, :url, :ident)
    end
end
