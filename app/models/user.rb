class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable

  attr_accessor :encrypted_password
end
