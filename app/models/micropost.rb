class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :content, presence: true,
                      length: {maximum: Settings.microposts.max_chars}
  validates :image, content_type: {in: Settings.img.formats,
                                   message: I18n.t("micropost.img_fmt_warn")},
                    size: {less_than: Settings.img.size_limit.megabytes,
                           message: I18n.t("micropost.img_size_warn")}

  scope :ordered, ->{order(created_at: :desc)}
  scope :by_users, ->(ids){where(user_id: ids)}

  delegate :name, to: :user, prefix: true

  def display_image
    image.variant(resize_to_limit: Settings.img.resolution_limit)
  end
end
