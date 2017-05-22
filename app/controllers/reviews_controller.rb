class ReviewsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @user = User.find(session[:user_id])
    @review = @user.reviews.create(review: params[:review], rating: params[:rating], book:@book)
    redirect_to controller: 'books', action: 'show', id: params[:book_id]  # "/books/#{@book.id}"
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to controller: 'books', action: 'show', id: @review.book_id
  end
end
