class FollowingController < ApplicationController
  before_action :logged_in_user, :find_user_by_id, only: :index

  def index
    @title = t "fl_ing_title"
    @pagy, @users = pagy(@user.following.order("name ASC"),
                         items: Settings.pagy.usr_per_page)
    render :show_follow
  end
end
