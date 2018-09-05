class Comment < ApplicationRecord
  belongs_to :task

  validates :body, length: { in: 10..256 }, presence: true
end
