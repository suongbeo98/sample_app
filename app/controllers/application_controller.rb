class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def hello
    render html: "hello, world!"
  end

  private

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".flash_danger"
    redirect_to login_path
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user?(@user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
