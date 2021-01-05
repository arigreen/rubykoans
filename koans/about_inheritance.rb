# typed: strict
require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutInheritance < Neo::Koan
  class Dog
    extend T::Sig

    sig {returns(String)}
    attr_reader :name

    sig {params(name: String).void}
    def initialize(name)
      @name = name
    end

    sig {returns(String)}
    def bark
      "WOOF"
    end
  end

  class Chihuahua < Dog
    sig {returns(Symbol)}
    def wag
      :happy
    end

    sig {returns(String)}
    def bark
      "yip"
    end
  end

  sig {void}
  def test_subclasses_have_the_parent_as_an_ancestor
    assert_equal true, Chihuahua.ancestors.include?(Dog)
  end

  sig {void}
  def test_all_classes_ultimately_inherit_from_object
    assert_equal true, Chihuahua.ancestors.include?(Object)
  end

  sig {void}
  def test_subclasses_inherit_behavior_from_parent_class
    chico = Chihuahua.new("Chico")
    assert_equal "Chico", chico.name
  end

  sig {void}
  def test_subclasses_add_new_behavior
    chico = Chihuahua.new("Chico")
    assert_equal :happy, chico.wag

    assert_raise(NoMethodError) do
      fido = Dog.new("Fido")
      T.unsafe(fido).wag
    end
  end

  sig {void}
  def test_subclasses_can_modify_existing_behavior
    chico = Chihuahua.new("Chico")
    assert_equal "yip", chico.bark

    fido = Dog.new("Fido")
    assert_equal "WOOF", fido.bark
  end

  # ------------------------------------------------------------------

  class BullDog < Dog
  sig {returns(String)}
    def bark
      super + ", GROWL"
    end
  end

  sig {void}
  def test_subclasses_can_invoke_parent_behavior_via_super
    ralph = BullDog.new("Ralph")
    assert_equal "WOOF, GROWL", ralph.bark
  end

  # ------------------------------------------------------------------

  class GreatDane < Dog
    sig {returns(String)}
    def growl
      super.bark + ", GROWL"
    end
  end

  sig {void}
  def test_super_does_not_work_cross_method
    george = GreatDane.new("George")
    assert_raise(NoMethodError) do
      george.growl
    end
  end

end
