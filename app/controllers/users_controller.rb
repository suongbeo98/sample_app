class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :load_user, except: %i(index new create)

  def index
    @users = User.paginate page: params[:page]
  end

  def show
    @microposts = @user.microposts.paginate page: params[:page]
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".flash_info"
      redirect_to root_url
    else
      render :new
    end
  end

  def new
    @user = User.new
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".flash_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".flash_success"
    else
      flash[:danger] =  t ".flash_danger"
    end
    redirect_to users_url
  end

  def following
    @title = t ".title"
    @users = @user.following.paginate page: params[:page]
    render "show_follow"
  end

  def followers
    @title = t ".title"
    @users = @user.followers.paginate page: params[:page]
    render "show_follow"
  end

  private

  def load_user
    return if (@user = User.find_by id: params[:id])
    flash[:danger] = t ".flash_danger"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end
end
