defmodule Momento.SubtractTest do
  use ExUnit.Case

  require Momento
  require Momento.Guards

  describe "years" do
    setup do
      %{datetime: %DateTime{Momento.date!() | year: 2016}}
    end

    test "should map singular to plural", %{datetime: shared_dt} do
      years = 1
      datetime = Momento.subtract(shared_dt, years, :year)

      assert datetime.year == shared_dt.year - years
    end

    test "should subtract nothing", %{datetime: shared_dt} do
      num = 0
      datetime = Momento.subtract(shared_dt, num, :years)

      assert datetime.year == shared_dt.year
    end

    test "should subtract some years", %{datetime: shared_dt} do
      num = 5
      datetime = Momento.subtract(shared_dt, num, :years)

      assert datetime.year == shared_dt.year - num
    end
  end

  describe "months" do
    setup do
      %{datetime: %DateTime{Momento.date!() | month: 6}}
    end

    test "should map singular to plural", %{datetime: shared_dt} do
      months = 1
      datetime = Momento.subtract(shared_dt, months, :month)

      assert datetime.month == shared_dt.month - months
    end

    test "should subtract nothing", %{datetime: shared_dt} do
      months = 0
      datetime = Momento.subtract(shared_dt, months, :months)

      assert datetime == shared_dt
    end

    test "should subtract months without rollover", %{datetime: shared_dt} do
      months = 3
      datetime = Momento.subtract(shared_dt, months, :months)

      assert datetime.year == shared_dt.year
      assert datetime.month == shared_dt.month - months
    end

    test "should subtract months and rollover years", %{datetime: shared_dt} do
      months = 19
      datetime = Momento.subtract(shared_dt, months, :months)

      assert datetime.year == shared_dt.year - 2
      assert datetime.month == 11
    end

    test "should only subtract years", %{datetime: shared_dt} do
      months = 24
      years = 24 / 12
      datetime = Momento.subtract(shared_dt, months, :months)

      assert datetime.year == shared_dt.year - years
      assert datetime.month == shared_dt.month
    end
  end

  describe "days" do
    setup do
      %{datetime: %DateTime{Momento.date!() | month: 6, day: 15}}
    end

    test "should map singular to plural", %{datetime: shared_dt} do
      days = 1
      datetime = Momento.subtract(shared_dt, days, :day)

      assert datetime.day == shared_dt.day - days
    end

    test "should subtract nothing", %{datetime: shared_dt} do
      days = 0
      datetime = Momento.subtract(shared_dt, days, :days)

      assert datetime == shared_dt
    end

    test "should subtract days without rollover", %{datetime: shared_dt} do
      days = 10
      datetime = Momento.subtract(shared_dt, days, :days)

      assert datetime.day == shared_dt.day - days
      assert datetime.month == shared_dt.month
    end

    test "should subtract days and rollover months", %{datetime: shared_dt} do
      days = 21
      datetime = Momento.subtract(shared_dt, days, :days)

      assert datetime.day == shared_dt.day + 10
      assert datetime.month == shared_dt.month - 1
    end

    test "should only subtract months", %{datetime: shared_dt} do
      days =
        Momento.Guards.days_in_month(shared_dt.month - 1) +
          Momento.Guards.days_in_month(shared_dt.month - 2) +
          Momento.Guards.days_in_month(shared_dt.month - 3)

      datetime = Momento.subtract(shared_dt, days, :days)

      assert datetime.day == shared_dt.day
      assert datetime.month == shared_dt.month - 3
    end
  end

  describe "hours" do
    setup do
      %{datetime: %DateTime{Momento.date!() | day: 15, hour: 9}}
    end

    test "should map singular to plural", %{datetime: shared_dt} do
      hours = 1
      datetime = Momento.subtract(shared_dt, hours, :hour)

      assert datetime.hour == shared_dt.hour - hours
    end

    test "should subtract nothing", %{datetime: shared_dt} do
      hours = 0
      datetime = Momento.subtract(shared_dt, hours, :hours)

      assert datetime == shared_dt
    end

    test "should subtract hours without rollover", %{datetime: shared_dt} do
      hours = 5
      datetime = Momento.subtract(shared_dt, hours, :hours)

      assert datetime.hour == shared_dt.hour - hours
      assert datetime.day == shared_dt.day
    end

    test "should subtract hours and rollover days", %{datetime: shared_dt} do
      hours = 15
      datetime = Momento.subtract(shared_dt, hours, :hours)

      assert datetime.hour == 18
      assert datetime.day == shared_dt.day - 1
    end

    test "should only subtract days", %{datetime: shared_dt} do
      hours = 48
      datetime = Momento.subtract(shared_dt, hours, :hours)

      assert datetime.hour == shared_dt.hour
      assert datetime.day == shared_dt.day - 2
    end
  end

  describe "minutes" do
    setup do
      %{datetime: %DateTime{Momento.date!() | hour: 12, minute: 15}}
    end

    test "should map singular to plural", %{datetime: shared_dt} do
      minutes = 1
      datetime = Momento.subtract(shared_dt, minutes, :minute)

      assert datetime.minute == shared_dt.minute - minutes
    end

    test "should subtract nothing", %{datetime: shared_dt} do
      minutes = 0
      datetime = Momento.subtract(shared_dt, minutes, :minutes)

      assert datetime == shared_dt
    end

    test "should subtract minutes without rollover", %{datetime: shared_dt} do
      minutes = 10
      datetime = Momento.subtract(shared_dt, minutes, :minutes)

      assert datetime.minute == shared_dt.minute - minutes
      assert datetime.hour == shared_dt.hour
    end

    test "should subtract minutes and rollover hours", %{datetime: shared_dt} do
      minutes = 150
      datetime = Momento.subtract(shared_dt, minutes, :minutes)

      assert datetime.minute == shared_dt.minute + 30
      assert datetime.hour == shared_dt.hour - 3
    end

    test "should only subtract hours", %{datetime: shared_dt} do
      minutes = 120
      datetime = Momento.subtract(shared_dt, minutes, :minutes)

      assert datetime.minute == shared_dt.minute
      assert datetime.hour == shared_dt.hour - 2
    end
  end

  describe "seconds" do
    setup do
      %{datetime: %DateTime{Momento.date!() | minute: 15, second: 15}}
    end

    test "should map singular to plural", %{datetime: shared_dt} do
      seconds = 1
      datetime = Momento.subtract(shared_dt, seconds, :second)

      assert datetime.second == shared_dt.second - seconds
    end

    test "should subtract nothing", %{datetime: shared_dt} do
      seconds = 0
      datetime = Momento.subtract(shared_dt, seconds, :seconds)

      assert datetime == shared_dt
    end

    test "should subtract seconds without rollover", %{datetime: shared_dt} do
      seconds = 10
      datetime = Momento.subtract(shared_dt, seconds, :seconds)

      assert datetime.second == shared_dt.second - seconds
      assert datetime.minute == shared_dt.minute
    end

    test "should subtract seconds and rollover minutes", %{datetime: shared_dt} do
      seconds = 150
      datetime = Momento.subtract(shared_dt, seconds, :seconds)

      assert datetime.second == shared_dt.second + 30
      assert datetime.minute == shared_dt.minute - 3
    end

    test "should subtract only minutes", %{datetime: shared_dt} do
      seconds = 120
      datetime = Momento.subtract(shared_dt, seconds, :seconds)

      assert datetime.second == shared_dt.second
      assert datetime.minute == shared_dt.minute - 2
    end
  end

  describe "microseconds" do
    setup do
      %{datetime: %DateTime{Momento.date!() | second: 15, microsecond: {123_456, 6}}}
    end

    test "should map singular to plural", %{datetime: shared_dt} do
      microseconds = 0
      datetime = Momento.subtract(shared_dt, microseconds, :microsecond)

      assert datetime == shared_dt
    end

    test "should subtract nothing", %{datetime: shared_dt} do
      microseconds = 0
      datetime = Momento.subtract(shared_dt, microseconds, :microseconds)

      assert datetime == shared_dt
    end

    test "should subtract microseconds without rollover", %{datetime: shared_dt} do
      microseconds = 111
      datetime = Momento.subtract(shared_dt, microseconds, :microseconds)
      {old_microsecond, old_precision} = shared_dt.microsecond
      {new_microsecond, new_precision} = datetime.microsecond

      assert new_microsecond == old_microsecond - microseconds
      assert new_precision == old_precision
    end

    test "should subtract microseconds and rollover seconds", %{datetime: shared_dt} do
      microseconds = 123_458
      datetime = Momento.subtract(shared_dt, microseconds, :microseconds)
      {_, old_precision} = shared_dt.microsecond
      {new_microsecond, new_precision} = datetime.microsecond

      assert new_microsecond == 999_998
      assert new_precision == old_precision
      assert datetime.second == shared_dt.second - 1
    end

    test "should only subtract seconds", %{datetime: shared_dt} do
      microseconds = 2_000_000
      datetime = Momento.subtract(shared_dt, microseconds, :microseconds)
      {old_microsecond, old_precision} = shared_dt.microsecond
      {new_microsecond, new_precision} = datetime.microsecond

      assert new_microsecond == old_microsecond
      assert new_precision == old_precision
      assert datetime.second == shared_dt.second - 2
    end
  end
end
