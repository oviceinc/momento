defmodule Momento.GuardsTest do
  use ExUnit.Case, async: true
  import Momento.Guards

  describe "natural?" do
    test "should be true if positive integer" do
      assert natural?(5)
    end

    test "should be true if zero" do
      assert natural?(0)
    end

    test "should be false if negative integer" do
      refute natural?(-5)
    end
  end

  describe "positive?" do
    test "should be true if positive integer" do
      assert positive?(5)
    end

    test "should be false if zero" do
      refute positive?(0)
    end

    test "should be false if negative integer" do
      refute positive?(-5)
    end
  end

  describe "negative?" do
    test "should be true if negative integer" do
      assert negative?(-5)
    end

    test "should be false if zero" do
      refute negative?(0)
    end

    test "should be false if positive integer" do
      refute negative?(5)
    end
  end

  describe "days_in_month" do
    test "should return the number of days in a given month where input is non-zero indexed" do
      assert days_in_month(2) == 28
    end

    test "should be circular in the forward direction" do
      assert days_in_month(13) == 31
    end

    test "should be circular in the backward direction" do
      assert days_in_month(0) == 31
    end

    test "should accept integers out of range" do
      assert days_in_month(14) == 28
    end
  end
end
