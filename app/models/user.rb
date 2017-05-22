class User < ActiveRecord::Base
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  has_secure_password
  has_many :reviews
  validates :first_name, :last_name,:email,:username,  presence: true
  validates :username, :first_name, :last_name, length: { minimum: 3 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
end
