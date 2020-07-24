class ChannelSocialsController < ApplicationController
  before_action :set_channel_social, only: [:show, :edit, :update, :destroy]

  # GET /channel_socials
  # GET /channel_socials.json
  def index
    @channel_socials = ChannelSocial.all
  end

  # GET /channel_socials/1
  # GET /channel_socials/1.json
  def show
  end

  # GET /channel_socials/new
  def new
    @channel_social = ChannelSocial.new
  end

  # GET /channel_socials/1/edit
  def edit
  end

  # POST /channel_socials
  # POST /channel_socials.json
  def create
    @channel_social = ChannelSocial.new(channel_social_params)

    respond_to do |format|
      if @channel_social.save
        format.html { redirect_to @channel_social, notice: 'Channel social was successfully created.' }
        format.json { render :show, status: :created, location: @channel_social }
      else
        format.html { render :new }
        format.json { render json: @channel_social.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /channel_socials/1
  # PATCH/PUT /channel_socials/1.json
  def update
    respond_to do |format|
      if @channel_social.update(channel_social_params)
        format.html { redirect_to @channel_social, notice: 'Channel social was successfully updated.' }
        format.json { render :show, status: :ok, location: @channel_social }
      else
        format.html { render :edit }
        format.json { render json: @channel_social.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channel_socials/1
  # DELETE /channel_socials/1.json
  def destroy
    @channel_social.destroy
    respond_to do |format|
      format.html { redirect_to channel_socials_url, notice: 'Channel social was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel_social
      @channel_social = ChannelSocial.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def channel_social_params
      params.require(:channel_social).permit(:channel, :url, :ident)
    end
end
