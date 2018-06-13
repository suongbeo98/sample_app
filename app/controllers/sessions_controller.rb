class SessionsController < ApplicationController
  def new; end

  def create
    session_hash = params[:session]
    @user = User.find_by email: session_hash[:email].downcase
    if @user && @user.authenticate(session_hash[:password])
      activated_check?
    else
      flash.now[:danger] = t ".flash_danger"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
