class User < ActiveRecord::Base
  include ActiveDirectoryLookups

  has_many :sign_users
  has_many :signs, through: :sign_users, dependent: :destroy, prevent_dups: true

  has_many :slide_users
  has_many :slides, through: :slide_users, dependent: :destroy, prevent_dups: true

  devise :database_authenticatable, :rememberable, :trackable

  enum role: { super_admin: 0 }

  scope :search, -> (search) { where("users.email ILIKE ?", "%#{search}%") if search.present? }

  attr_accessor :encrypted_password # Just to make :database_authenticatable work

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def full_name_with_email
    "#{first_name} #{last_name} (#{email})"
  end
end

# An unknown user
class UnknownUser
  def full_name
    "Unknown user"
  end
end