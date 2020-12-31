#!/usr/bin/env ruby
# typed: strict
# -*- ruby -*-

require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutAsserts < Neo::Koan

  # We shall contemplate truth by testing reality, via asserts.
  sig{void}
  def test_assert_truth
    assert true                # This should be true
  end

  # Enlightenment may be more easily achieved with appropriate
  # messages.
  sig{void}
  def test_assert_with_message
    assert true, "This should be true -- Please fix this"
  end

  # To understand reality, we must compare our expectations against
  # reality.
  sig{void}
  def test_assert_equality
    expected_value = 2
    actual_value = 1 + 1

    assert expected_value == actual_value
  end

  # Some ways of asserting equality are better than others.
  sig{void}
  def test_a_better_way_of_asserting_equality
    expected_value = 2
    actual_value = 1 + 1

    assert_equal expected_value, actual_value
  end

  # Sometimes we will ask you to fill in the values
  sig{void}
  def test_fill_in_values
    assert_equal 2, 1 + 1
  end
end
