class BooksController < ApplicationController




  def index
    @book = Book.new
    #7/16ソート機能のためにorder(params[:sort])を
    # @books = Book.all.order(params[:sort])
        to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    @books = Book.all.sort {|a,b| 
      b.favorites.where(created_at: from...to).size <=> 
      a.favorites.where(created_at: from...to).size
    }
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
        read_count = ReadCount.new(book_id: @book.id, user_id: current_user.id)
    #ReadCountを新しく作成し、book_idに取得してきた本のid、user_idにcurrent_user = つまり自分のidを入力
    read_count.save
    #上２行を纏めて書くとこちら
    current_user.read_counts.create(book_id: @book.id)#createはsave不要
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
       user = @book.user
  unless user.id == current_user.id
    redirect_to books_path
  end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :star)
  end
end
