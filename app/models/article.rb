class Article < ApplicationRecord
  include Concerns::CheckPostTime

  has_many :images, as: :imageable, dependent: :destroy
  belongs_to :company
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  validates :description, presence: true
  validate :check_time_show

  delegate :name, to: :company, prefix: true

  accepts_nested_attributes_for :images
  ATTRIBUTES = [:title, :content, :description, :time_show,
    images_attributes: [:id, :imageable_id, :imageable_type, :picture,
    :caption]].freeze

  scope :search_form, ->(search, type, sort_by) do
    where("LOWER(title) LIKE ? OR LOWER(description) LIKE ?",
      "%#{search}%", "%#{search}%").order "#{type} #{sort_by}"
  end

  # only use with user's view
  scope :time_filter, -> time_show do
    where("#{time_show} <= ?", format_time(Time.zone.now, :format_datetime))
      .order "#{time_show} DESC"
  end

  def background_image
    images.first.picture
  end

  private

  def check_time_show
    check_time time_show
  end
end
