module UniqueHasManyThroughJoinTableTest

  def test_join_is_definately_unique
    assoc_method_name = @right_object.class.name.underscore.pluralize.to_sym
    @left_object.send(assoc_method_name).clear
    @left_object.send(assoc_method_name) << @right_object
    assert_raise ActiveRecord::RecordInvalid do
      @left_object.send(assoc_method_name) << @right_object
    end
  end
end