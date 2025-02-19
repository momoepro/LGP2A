class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  attr_accessor :room_translations
  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  ###########################################

  def get_room
    room = Room.find_by_id params[:id]
    if !room.blank?
      render :json => {:success => "true", :room => room}
    else
      render :json => {:success => "false"}
    end
  end

  def get_room_photos
    room = Room.find_by_id params[:id]
    if !room.blank?
      render :json => {:success => "true", :room_id => room.id, :photos => room.photos}
    else
      render :json => {:success => "false"}
    end
  end

  def get_everything

    #most correct/efficient approach
    #render :json => Room.all.to_json({:include => { :photos => {:include => { :points => {}} }}})

    #different approach that allows custom keys to some objects.
    result = {}
    Room.all.each do |room|
      room_temp = room.attributes
      room_temp[:photos] = Array.new

      room.photos.each do |photo|
        photo_temp = photo.attributes
        photo_temp[:points] = Array.new

        photo.points.each do |point|
          point_temp = point.attributes
          photo_temp[:points].push(point_temp)
        end
        room_temp[:photos].push(photo_temp)
      end

      room_temp[:translations] = {}
      room.room_translations.each do |translation|
        translation_temp = translation.attributes
        translation_language = Language.find(translation.language_id).code
        room_temp[:translations][translation_language] = translation_temp
      end

      result[room.code] = room_temp
    end

    render :json => result
    
  end
  ###########################################



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.fetch(:room, {})
    end
end
