class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(microposts_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = t "micropost.created_noti"
      redirect_to root_url
    else
      @pagy, @feed_items = pagy(current_user.feed,
                                items: Settings.pagy.micro_per_page)
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost.noti"
    else
      flash[:danger] = t "error.post.not_deleted"
    end
    redirect_back(fallback_location: root_url)
  end

  private

  def microposts_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.blank?
  end
end
