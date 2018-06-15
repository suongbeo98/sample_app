class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    if @user = User.find_by id: params[:followed_id]
      current_user.follow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t ".flash_danger"
      redirect_to current_user
    end
  end

  def destroy
    if @user = Relationship.find_by(id: params[:id]).followed
      current_user.unfollow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t ".flash_danger"
      redirect_to current_user
    end
  end
end
