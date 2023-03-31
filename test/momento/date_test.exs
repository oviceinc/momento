defmodule Momento.DateTest do
  use ExUnit.Case, async: true

  require Momento
  require Momento.Guards

  describe "date" do
    test "should return exactly what was given" do
      {:ok, datetime} = Momento.date()
      {:ok, same_datetime} = Momento.date(datetime)

      assert datetime == same_datetime
    end

    test "should return a DateTime struct from a unix timestamp in seconds" do
      {:ok, datetime} = Momento.date(1_467_316_077)

      assert %DateTime{} = datetime
    end

    test "should return a DateTime struct from a unix timestamp in milliseconds" do
      {:ok, datetime} = Momento.date(1_467_316_261_999)

      assert %DateTime{} = datetime
    end

    test "should return a DateTime struct from a unix timestamp in microseconds" do
      {:ok, datetime} = Momento.date(1_467_316_272_333_763)

      assert %DateTime{} = datetime
    end

    test "should return a DateTime struct from a unix timestamp in nanoseconds" do
      {:ok, datetime} = Momento.date(1_467_316_281_921_158_374)

      assert %DateTime{} = datetime
    end

    test "ISO8601 - should return a DateTime struct from a ISO8601 string" do
      {:ok, datetime} = Momento.date("2016-04-20T15:05:13.991Z")

      assert %{
               year: 2016,
               month: 4,
               day: 20,
               hour: 15,
               minute: 5,
               second: 13,
               microsecond: {991_000, 6}
             } = datetime
    end

    test "ISO - should return a DateTime struct from a ISO date string" do
      {:ok, datetime} = Momento.date("2016-04-20")

      assert %{year: 2016, month: 4, day: 20} = datetime
    end
  end

  describe "date!" do
    test "should return value" do
      assert %DateTime{} = Momento.date!(1_467_316_077)
    end
  end
end
