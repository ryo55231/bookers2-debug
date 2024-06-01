class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end
  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
       @users = User.all
    render :edit
    end

  end
  # 1. followメソッド　＝　フォローする
  def follow(user_id)
   follower.create(followed_id: user_id)
  end

  # 2. unfollowメソッド　＝　フォローを外す
  def unfollow(user_id)
   follower.find_by(followed_id: user_id).destroy
  end

  # 3. followingメソッド　＝　既にフォローしているかの確認
  def following?(user)
   following_user.include?(user)
  end
  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
