class BooksController < ApplicationController
  def index
    if session[:user_id].nil?
      return redirect_to '/'
    end
    @reviews = Review.all.limit(3).order("created_at DESC")
    # @other_reviews = Review.select('DISTINCT book_id').order("created_at DESC")
    @other_reviews = Review.joins(:book).select('DISTINCT books.*').order('books.title')

  end

  def show
    if session[:user_id].nil?
      return redirect_to '/'
    end 
    @book = Book.find(params[:id])
    @reviews = @book.reviews
  end

  def new
    if session[:user_id].nil?
      return redirect_to '/'
    end
    @authors=Author.all
  end

  def create
    @author = Author.find_by(params[:list_authors])
    if @author
      @book = Book.create(title: params[:title], author: @author)
    else
      @new_author = Author.create(name: params[:author])
      @book = Book.create(title: params[:title], author: @new_author)
    end
    @user = User.find(session[:user_id])
    @review = @user.reviews.create(review: params[:review], rating: params[:rating], book:@book)
    redirect_to '/books'
  end
end
