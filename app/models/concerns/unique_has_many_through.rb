module UniqueHasManyThrough
  extend ActiveSupport::Concern

  class_methods do

    # The Macro
    #
    # Sets up all the associations the way I like it.  Also adds nice methods
    # that make sure we only add unique values to the association array.
    #
    def unique_has_many_through(association, join_table)

      # I want to save the association for testing purposes
      unique_has_many_through_reflections << association

      has_many join_table
      has_many association, through: join_table, dependent: :destroy

      define_method "add_#{association.to_s.singularize}" do |item|
        send(association).push(item) unless send(association).include?(item)
      end

      define_method "remove_#{association.to_s.singularize}" do |item|
        send(association).delete(item)
      end
    end

    #
    # Save the associations in an array so that we can setup sexy tests
    #
    def unique_has_many_through_reflections
      @unique_has_many_through_reflections ||= []
    end
  end
end