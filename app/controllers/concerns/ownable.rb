module Ownable
  extend ActiveSupport::Concern

  included do |base|
    before_action :lookup_in_active_directory, only: [:autocomplete_user_email]
    before_action :set_owner, only: [:add_owner, :remove_owner]
    before_action :set_owned_object, only: [:add_owner, :remove_owner]

    autocomplete :user, :email, extra_data: [:id, :first_name, :last_name], display_value: :full_name_with_email, full: true
  end

  def add_owner
    @new_owner = !@owned_object.users.include?(@owner)
    @owned_object.add_user @owner
    render 'ownable/add_owner'
  end

  def remove_owner
    @owned_object.remove_user User.find(params[:user_id])
    render 'ownable/remove_owner'
  end

  private

    def set_owner
      @owner = User.find(params[:user_id])
    end

    def lookup_in_active_directory
      User.create_or_update_from_active_directory(params[:term])
    rescue UnexpectedActiveDirectoryFormat
    end

    def set_owned_object
      raise "You need to set a variable called @owned_object in a private method called set_owned_object in the controller."
    end
end