class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  attr_accessor :remember_token
  validates :email, presence: true
  validates :email, length: {maximum: Settings.user.email_max}
  validates :email, format: {with: VALID_EMAIL_REGEX}
  validates :email, uniqueness: {case_sensitive: false}
  validates :password, presence: true
  validates :password, length: {minimum: Settings.user.pass_min}, allow_nil: true
  validates :name, presence: true, length: {maximum: Settings.user.name_max}
  before_save{email.downcase!}
  has_secure_password

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attributes remember_digest: nil
  end
end
