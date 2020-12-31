# typed: strict
require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutTrueAndFalse < Neo::Koan

  sig{params(condition: T.untyped).returns(Symbol)}
  def truth_value(condition)
    if condition
      :true_stuff
    else
      :false_stuff
    end
  end

  sig {void}
  def test_true_is_treated_as_true
    assert_equal :true_stuff, truth_value(true)
  end

  sig {void}
  def test_false_is_treated_as_false
    assert_equal :false_stuff, truth_value(false)
  end

  sig {void}
  def test_nil_is_treated_as_false_too
    assert_equal :false_stuff, truth_value(nil)
  end

  sig {void}
  def test_everything_else_is_treated_as_true
    assert_equal :true_stuff, truth_value(1)
    assert_equal :true_stuff, truth_value(0)
    assert_equal :true_stuff, truth_value([])
    assert_equal :true_stuff, truth_value({})
    assert_equal :true_stuff, truth_value("Strings")
    assert_equal :true_stuff, truth_value("")
  end

end
