class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true
  validates :email, length: {maximum: Settings.user.email_max}
  validates :email, format: {with: VALID_EMAIL_REGEX}
  validates :email, uniqueness: {case_sensitive: false}
  validates :password, presence: true
  validates :password, length: {minimum: Settings.user.pass_min}
  validates :name, presence: true, length: {maximum: Settings.user.name_max}
  before_save{email.downcase!}
  has_secure_password
end
