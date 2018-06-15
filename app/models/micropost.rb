class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.content_min}
  validate :picture_size
  default_scope ->{order created_at: :desc}
  scope :related_micropost, ->(user){where("user_id IN (?) OR user_id = ?", user.following_ids, user.id)}
  mount_uploader :picture, PictureUploader

  private

  def picture_size
    return unless picture.size > Settings.upload_picture_size.megabytes
    errors.add :picture, I18n.t("upload_size_error")
  end
end
