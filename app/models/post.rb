class Post < ApplicationRecord
  searchkick
  include PostShare

  belongs_to :postable, polymorphic: true

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :share_posts, as: :shareable, class_name: ShareJob.name,
    dependent: :destroy

  validates :title, presence: true, length: {maximum: Settings.post.title_max}
  validates :content, presence: true

  delegate :name, to: :postable, prefix: true

  scope :newest, ->{order created_at: :desc}

  mount_uploader :image, PictureUploader
end
