class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :projects, dependent: :destroy

  def tokens_has_json_column_type?
    false
  end
end
