class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".flash_info"
      redirect_to root_url
    else
      flash.now[:danger] = t ".flash_danger"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".empty_pass")
      render :edit
    elsif @user.update_attributes user_params
      update_success
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    return if (@user = User.find_by email: params[:email])
    flash[:danger] = t ".flash_danger"
    redirect_to root_url
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])
    flash[:danger] = t ".flash_danger"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t ".flash_danger"
    redirect_to new_password_reset_url
  end

  def update_success
    log_in @user
    @user.update_attributes reset_digest: nil
    flash[:success] = t ".flash_success"
    redirect_to @user
  end
end
