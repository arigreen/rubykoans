# typed: strict
require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutOpenClasses < Neo::Koan
  class Dog
    extend T::Sig

    sig {returns(String)}
    def bark
      "WOOF"
    end
  end

  sig {void}
  def test_as_defined_dogs_do_bark
    fido = Dog.new
    assert_equal "WOOF", fido.bark
  end

  # ------------------------------------------------------------------

  # Open the existing Dog class and add a new method.
  class Dog
    sig {returns(String)}
    def wag
      "HAPPY"
    end
  end

  sig {void}
  def test_after_reopening_dogs_can_both_wag_and_bark
    fido = Dog.new
    assert_equal "HAPPY", fido.wag
    assert_equal "WOOF", fido.bark
  end

  # ------------------------------------------------------------------

  class ::Integer
    extend T::Sig

    sig {returns(T::Boolean)}
    def even?
      (self % 2) == 0
    end
  end

  sig {void}
  def test_even_existing_built_in_classes_can_be_reopened
    assert_equal false, 1.even?
    assert_equal true, 2.even?
  end

  # NOTE: To understand why we need the :: before Integer, you need to
  # become enlightened about scope.
end
