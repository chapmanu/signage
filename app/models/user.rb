class User < ActiveRecord::Base
  has_many :device_users, dependent: :destroy
  has_many :devices, through: :device_users
  has_many :slides, -> { uniq }, through: :devices

  devise :database_authenticatable, :rememberable, :trackable

  enum roll: { super_admin: 0 }

  attr_accessor :encrypted_password # Just to make :database_authenticatable work

  def devices
    super_admin? ? Device.all : super
  end

  def slides
    super_admin? ? Slide.all : super
  end
end