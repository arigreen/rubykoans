# typed: strict
require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutMethods < Neo::Koan
  # TODO: When this method was global in the file scope,
  # I was unable to call the method using T.unsafe, thus
  # I made it an instance method. I am interested in learning
  # how to call a global method with T.unsafe.
  sig {params(a: Integer, b: Integer).returns(Integer)}
  def my_global_method(a,b)
    a + b
  end

  sig {void}
  def test_calling_global_methods
    assert_equal 5, my_global_method(2,3)
  end

  sig {void}
  def test_calling_global_methods_without_parentheses
    result = my_global_method 2, 3
    assert_equal 5, result
  end

  # (NOTE: We are Using eval below because the example code is
  # considered to be syntactically invalid).
  sig {void}
  def test_sometimes_missing_parentheses_are_ambiguous
    eval "assert_equal 5, my_global_method(2, 3)" # ENABLE CHECK
    #
    # Ruby doesn't know if you mean:
    #
    #   assert_equal(5, my_global_method(2), 3)
    # or
    #   assert_equal(5, my_global_method(2, 3))
    #
    # Rewrite the eval string to continue.
    #
  end

  # NOTE: wrong number of arguments is not a SYNTAX error, but a
  # runtime error.
  sig {void}
  def test_calling_global_methods_with_wrong_number_of_arguments
    exception = assert_raise(ArgumentError) do
      T.unsafe(self).my_global_method
    end
    assert_match(/wrong number of arguments/, exception.message)

    exception = assert_raise(ArgumentError) do
      T.unsafe(self).my_global_method(1,2,3)
    end
    assert_match(/wrong number of arguments/, exception.message)
  end

  # ------------------------------------------------------------------

  IntegerOrSymbol = T.type_alias {T.any(Integer, Symbol)}

  sig {params(a: Integer, b: IntegerOrSymbol).returns(T::Array[T.any(Integer, Symbol)])}
  def method_with_defaults(a, b=:default_value)
    [a, b]
  end

  sig {void}
  def test_calling_with_default_values
    assert_equal [1, :default_value], method_with_defaults(1)
    assert_equal [1, 2], method_with_defaults(1, 2)
  end

  # ------------------------------------------------------------------

  sig {params(args: IntegerOrSymbol).returns(T::Array[IntegerOrSymbol])}
  def method_with_var_args(*args)
    args
  end

  sig {void}
  def test_calling_with_variable_arguments
    assert_equal Array, method_with_var_args.class
    assert_equal [], method_with_var_args
    assert_equal [:one], method_with_var_args(:one)
    assert_equal [:one, :two], method_with_var_args(:one, :two)
  end

  # ------------------------------------------------------------------

  sig {returns(Symbol)}
  def method_with_explicit_return
    :a_non_return_value
    return :return_value
    :another_non_return_value
  end

  sig {void}
  def test_method_with_explicit_return
    assert_equal :return_value, method_with_explicit_return
  end

  # ------------------------------------------------------------------

  sig {returns(Symbol)}
  def method_without_explicit_return
    :a_non_return_value
    :return_value
  end

  sig {void}
  def test_method_without_explicit_return
    assert_equal :return_value, method_without_explicit_return
  end

  # ------------------------------------------------------------------

  sig {params(a: Integer, b: Integer).returns(Integer)}
  def my_method_in_the_same_class(a, b)
    a * b
  end

  sig {void}
  def test_calling_methods_in_same_class
    assert_equal 12, my_method_in_the_same_class(3,4)
  end

  sig {void}
  def test_calling_methods_in_same_class_with_explicit_receiver
    assert_equal 12, self.my_method_in_the_same_class(3,4)
  end

  # ------------------------------------------------------------------

  sig {returns(String)}
  def my_private_method
    "a secret"
  end
  private :my_private_method

  sig {void}
  def test_calling_private_methods_without_receiver
    assert_equal "a secret", my_private_method
  end

  if before_ruby_version("2.7")   # https://github.com/edgecase/ruby_koans/issues/12
    sig {void}
    def test_calling_private_methods_with_an_explicit_receiver
      exception = assert_raise(NoMethodError) do
        self.my_private_method
      end
      assert_match /private method/, exception.message
    end
  end

  # ------------------------------------------------------------------

  class Dog
    extend T::Sig

    sig {returns(String)}
    def name
      "Fido"
    end

    private

    sig {returns(String)}
    def tail
      "tail"
    end
  end

  sig {void}
  def test_calling_methods_in_other_objects_require_explicit_receiver
    rover = Dog.new
    assert_equal "Fido", rover.name
  end

  sig {void}
  def test_calling_private_methods_in_other_objects
    rover = Dog.new
    assert_raise(NoMethodError) do
      rover.tail
    end
  end
end
