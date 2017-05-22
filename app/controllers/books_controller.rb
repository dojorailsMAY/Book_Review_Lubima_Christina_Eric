class BooksController < ApplicationController
  def index
    if session[:user_id].nil?
      return redirect_to '/'
    end
    # @reviews = Review.all.limit(3).order("created_at DESC")
              # because we are using both `review.book.title` and `review.user.username` in html
    @reviews = Review.limit(3).order('created_at DESC').includes(:book).includes(:user)  
    # @other_reviews = Review.select('DISTINCT book_id').order("created_at DESC")
    @other_reviews = Review.joins(:book).select('DISTINCT books.*').order('books.title')

  end

  def show
    if session[:user_id].nil?
      return redirect_to '/'
    end 
    @book = Book.find(params[:id])
    # @author = @book.author  # do all sql queries in controller
    @reviews = @book.reviews.includes(:user)  # eager load users
  end

  def new
    if session[:user_id].nil?
      return redirect_to '/'
    end
    @authors=Author.all
  end

  def create

    if params[:author].length > 0  # check author input first
      @new_author = Author.create(name: params[:author])  # rename to :author_name
      @book = Book.create(title: params[:title], author: @new_author)
    else
      @author = Author.find_by(params[:list_authors])  # rename to :author_id
      @book = Book.create(title: params[:title], author: @author)
    end
    @user = User.find(session[:user_id])  # rename from :review to :content or :text
    @review = @user.reviews.create(review: params[:review], rating: params[:rating], book:@book)
    redirect_to '/books'
  end
end
