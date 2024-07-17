class ChatsController < ApplicationController
  before_action :following_check, only: [:show]
  
  def show
    @user = User.find(params[:id])#① 送られてきたidでUserを検索
    rooms = current_user.user_rooms.pluck(:room_id) #② current_userの持つroom_idを取得
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms) #③ ①と②を用いて合致するUserRoomが有るか探す
    unless user_rooms.nil?
      @room = user_rooms.room
    else
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end
    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
    redirect_to request.referer
  end

  private
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end
  
  def following_check
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to books_path
    end
  end
end
