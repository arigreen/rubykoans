# typed: strict
require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutModules < Neo::Koan

  module Nameable
    extend T::Sig

    sig {params(new_name: String).void}
    def set_name(new_name)
      # TODO: Can modules access instance variables?
      @name = T.let(new_name, T.nilable(String))
    end

    sig {returns(Symbol)}
    def here
      :in_module
    end
  end

  sig {void}
  def test_cant_instantiate_modules
    assert_raise(NoMethodError) do
      T.unsafe(Nameable).new
    end
  end

  # ------------------------------------------------------------------

  class Dog
    extend T::Sig
    include Nameable

    sig {returns(String)}
    attr_reader :name

    sig {void}
    def initialize
      @name = T.let("Fido", String)
    end

    sig {returns(String)}
    def bark
      "WOOF"
    end

    sig {returns(Symbol)}
    def here
      :in_object
    end
  end

  sig {void}
  def test_normal_methods_are_available_in_the_object
    fido = Dog.new
    assert_equal "WOOF", fido.bark
  end

  sig {void}
  def test_module_methods_are_also_available_in_the_object
    fido = Dog.new
    assert_nothing_raised do
      fido.set_name("Rover")
    end
  end

  sig {void}
  def test_module_methods_can_affect_instance_variables_in_the_object
    fido = Dog.new
    assert_equal "Fido", fido.name
    fido.set_name("Rover")
    assert_equal "Rover", fido.name
  end

  sig {void}
  def test_classes_can_override_module_methods
    fido = Dog.new
    assert_equal :in_object, fido.here
  end
end
