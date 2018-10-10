class Comment < ApplicationRecord
  belongs_to :task, counter_cache: true
  has_one_attached :image

  validates :body, length: { in: 10..256 }, presence: true
  validate :image_validation

  private

  def image_validation
    return unless image.attached?

    errors.add(:image, 'must be a JPEG or PNG') unless image.content_type.in?(%w[image/jpeg image/png])
    return if image.blob.byte_size < 10_000_000

    image.purge
    errors.add(:image, 'size must be less than 10Mb')
  end
end
