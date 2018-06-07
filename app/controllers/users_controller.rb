class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user
    flash[:warning] = t ".flash_success"
    redirect_to signup_path
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".flash_success"
      redirect_to @user
    else
      render :new
    end
  end

  def new
    @user = User.new
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end
end
