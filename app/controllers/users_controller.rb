class UsersController < ApplicationController
  def index
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      session[:username] = @user.username
      redirect_to '/books'
    else
       flash[:errors] = @user.errors.full_messages
       redirect_to '/'       
    end
  end

  def login
    @user = User.find_by(email: user_params[:email]).try(:authenticate,user_params[:password])
    if @user
      session[:user_id] = @user.id
      session[:username] = @user.username
      redirect_to '/books'
    else
      flash[:errors] = ["User not found. Please, register!"]
      redirect_to "/"
    end
  end

  def logout
    session[:user_id] = nil
    session[:username] = nil
    redirect_to '/'
  end

  def show
    if session[:user_id].nil?
      return redirect_to '/'
    end
    @user = User.find(params[:id])
    @count =@user.reviews.count 
    # @reviews =@user.reviews
    @reviews = @user.reviews.includes(:book)  # because we are using `review.book`, eager load all reviews' books
  end

private

  def user_params
    params.require(:user).permit(:first_name,:last_name,:username,:email,:password, :password_confirmation)
  end
end
