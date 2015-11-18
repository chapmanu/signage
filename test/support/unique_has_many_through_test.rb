module UniqueHasManyThroughTest

  def test_responds_to_unique_has_many_through_reflections
    assert @object.class.respond_to?(:unique_has_many_through_reflections)
  end

  def test_responds_to_generated_add_methods
    each_association do |assoc|
      assert @object.respond_to?(add_method_sym(assoc))
    end
  end

  def test_responds_to_generated_remove_methods
    each_association do |assoc|
      assert @object.respond_to?(remove_method_sym(assoc))
    end
  end

  def test_add_association
    each_association do |assoc|
      item = send(assoc, :one) # get it from the fixtures
      @object.send(assoc).clear
      @object.send(add_method_sym(assoc), item)
      @object.send(add_method_sym(assoc), item) # Twice to test the uniqe part
      assert_equal 1, @object.send(assoc).length
    end
  end

  def test_remove_association
    each_association do |assoc|
      item = send(assoc, :one) # get it from the fixtures
      @object.send(assoc).clear
      @object.send(add_method_sym(assoc), item)
      @object.send(remove_method_sym(assoc), item)
      @object.reload
      assert @object.send(assoc).empty?
    end
  end

  private
    def each_association
      @object.class.unique_has_many_through_reflections.each do |association|
        yield(association)
      end
    end

    def add_method_sym(association)
      :"add_#{association.to_s.singularize}"
    end

    def remove_method_sym(association)
      :"remove_#{association.to_s.singularize}"
    end
end