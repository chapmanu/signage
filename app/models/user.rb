class User < ActiveRecord::Base
  include ActiveDirectoryLookups

  include UniqueHasManyThrough
  unique_has_many_through :signs, :sign_users
  unique_has_many_through :slides, :slide_users

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