class FavoritesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @book = Book.find(params[:book_id])
    favorite = @book.favorites.new(user_id: current_user.id)
    #favorite = current_user.favorites.new(book_id: book.id)
    favorite.save
    #redirect_to request.referer
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = @book.favorites.find_by(user_id: current_user.id)
    #favorite = current_user.favorites.find_by(book_id: book.id)
    favorite.destroy
    #redirect_to request.referer非同期通信化のため無効
  end

end
