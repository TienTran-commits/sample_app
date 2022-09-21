class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_followed_user, only: :create
  before_action :load_relationship, :load_followed_user, only: :destroy

  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    current_user.unfollow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def find_followed_user
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:danger] = t "error.usr_not_found"
    redirect_to root_path
  end

  def load_relationship
    @relationship = Relationship.find_by(id: params[:id]).followed
    return if @relationship

    flash[:danger] = t "error.relationship_not_found"
    redirect_to root_path
  end

  def load_followed_user
    @user = @relationship.followed
    return if @user

    flash[:danger] = t "error.usr_not_found"
    redirect_to root_path
  end
end
