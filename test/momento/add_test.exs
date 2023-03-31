defmodule Momento.AddTest do
  use ExUnit.Case, async: true

  require Momento
  require Momento.Guards

  describe "years" do
    setup do
      %{datetime: %DateTime{Momento.date!() | year: 2016}}
    end

    test "should map singular to plural", %{datetime: shared_dt} do
      years = 1
      datetime = Momento.add(shared_dt, years, :year)

      assert datetime.year == shared_dt.year + years
    end

    test "should add nothing", %{datetime: shared_dt} do
      years = 0
      datetime = Momento.add(shared_dt, years, :years)

      assert datetime.year == shared_dt.year + years
    end

    test "should add some years", %{datetime: shared_dt} do
      years = 5
      datetime = Momento.add(shared_dt, years, :years)

      assert datetime.year == shared_dt.year + years
    end
  end

  describe "months" do
    setup do
      %{datetime: %DateTime{Momento.date!() | month: 6}}
    end

    test "should map singular to plural", %{datetime: shared_dt} do
      months = 1
      datetime = Momento.add(shared_dt, months, :month)

      assert datetime.month == shared_dt.month + months
    end

    test "should add nothing", %{datetime: shared_dt} do
      months = 0
      datetime = Momento.add(shared_dt, months, :months)

      assert datetime.month == shared_dt.month
    end

    test "should add months without rollover", %{datetime: shared_dt} do
      months = 3
      datetime = Momento.add(shared_dt, months, :months)

      assert datetime.year == shared_dt.year
      assert datetime.month == shared_dt.month + months
    end

    test "should add months and rollover years", %{datetime: shared_dt} do
      months = 19
      datetime = Momento.add(shared_dt, months, :months)

      assert datetime.year == shared_dt.year + 2
      assert datetime.month == 1
    end

    test "should only add years", %{datetime: shared_dt} do
      months = 24
      years = 24 / 12
      datetime = Momento.add(shared_dt, months, :months)

      assert datetime.year == shared_dt.year + years
      assert datetime.month == shared_dt.month
    end
  end

  describe "days" do
    setup do
      %{datetime: %DateTime{Momento.date!() | month: 6, day: 15}}
    end

    test "should map singular to plural", %{datetime: shared_dt} do
      days = 1
      datetime = Momento.add(shared_dt, days, :day)

      assert datetime.day == shared_dt.day + days
    end

    test "should add nothing", %{datetime: shared_dt} do
      days = 0
      datetime = Momento.add(shared_dt, days, :days)

      assert datetime.day == shared_dt.day
    end

    test "should add days without rollover", %{datetime: shared_dt} do
      days = 10
      datetime = Momento.add(shared_dt, days, :days)

      assert datetime.day == shared_dt.day + days
      assert datetime.month == shared_dt.month
    end

    test "should add days and rollover months", %{datetime: shared_dt} do
      days = 21
      datetime = Momento.add(shared_dt, days, :days)

      assert datetime.day == 6
      assert datetime.month == shared_dt.month + 1
    end

    test "should only add months", %{datetime: shared_dt} do
      days =
        Momento.Guards.days_in_month(shared_dt.month) +
          Momento.Guards.days_in_month(shared_dt.month + 1) +
          Momento.Guards.days_in_month(shared_dt.month + 2)

      datetime = Momento.add(shared_dt, days, :days)

      assert datetime.day == shared_dt.day
      assert datetime.month == shared_dt.month + 3
    end
  end

  describe "hours" do
    setup do
      %{datetime: %DateTime{Momento.date!() | day: 15, hour: 12}}
    end

    test "should map singular to plural", %{datetime: shared_dt} do
      hours = 1
      datetime = Momento.add(shared_dt, hours, :hour)

      assert datetime.hour == shared_dt.hour + hours
    end

    test "should add nothing", %{datetime: shared_dt} do
      hours = 0
      datetime = Momento.add(shared_dt, hours, :hours)

      assert datetime.hour == shared_dt.hour
    end

    test "should add hours without rollover", %{datetime: shared_dt} do
      hours = 5
      datetime = Momento.add(shared_dt, hours, :hours)

      assert datetime.hour == shared_dt.hour + hours
      assert datetime.day == shared_dt.day
    end

    test "should add hours and rollover days", %{datetime: shared_dt} do
      hours = 15
      datetime = Momento.add(shared_dt, hours, :hours)

      assert datetime.hour == 3
      assert datetime.day == shared_dt.day + 1
    end

    test "should only add days", %{datetime: shared_dt} do
      hours = 48
      datetime = Momento.add(shared_dt, hours, :hours)

      assert datetime.hour == shared_dt.hour
      assert datetime.day == shared_dt.day + 2
    end
  end

  describe "minutes" do
    setup do
      %{datetime: %DateTime{Momento.date!() | hour: 12, minute: 15}}
    end

    test "should map singular to plural", %{datetime: shared_dt} do
      minutes = 1
      datetime = Momento.add(shared_dt, minutes, :minute)

      assert datetime.minute == shared_dt.minute + minutes
    end

    test "should add nothing", %{datetime: shared_dt} do
      minutes = 0
      datetime = Momento.add(shared_dt, minutes, :minutes)

      assert datetime == shared_dt
    end

    test "should add minutes without rollover", %{datetime: shared_dt} do
      minutes = 30
      datetime = Momento.add(shared_dt, minutes, :minutes)

      assert datetime.minute == shared_dt.minute + minutes
      assert datetime.hour == shared_dt.hour
    end

    test "should add minutes and rollover hours", %{datetime: shared_dt} do
      minutes = 50
      datetime = Momento.add(shared_dt, minutes, :minutes)

      assert datetime.minute == 4
      assert datetime.hour == shared_dt.hour + 1
    end

    test "should only add hours", %{datetime: shared_dt} do
      minutes = 120
      datetime = Momento.add(shared_dt, minutes, :minutes)

      assert datetime.minute == shared_dt.minute
      assert datetime.hour == shared_dt.hour + 2
    end
  end

  describe "seconds" do
    setup do
      %{datetime: %DateTime{Momento.date!() | minute: 15, second: 15}}
    end

    test "should map singular to plural", %{datetime: shared_dt} do
      seconds = 1
      datetime = Momento.add(shared_dt, seconds, :second)

      assert datetime.minute == shared_dt.minute
    end

    test "should add nothing", %{datetime: shared_dt} do
      seconds = 0
      datetime = Momento.add(shared_dt, seconds, :seconds)

      assert datetime.minute == shared_dt.minute
    end

    test "should add seconds without rollover", %{datetime: shared_dt} do
      seconds = 30
      datetime = Momento.add(shared_dt, seconds, :seconds)

      assert datetime.minute == shared_dt.minute
      assert datetime.second == shared_dt.second + seconds
    end

    test "should add seconds and rollover minutes", %{datetime: shared_dt} do
      seconds = 50
      datetime = Momento.add(shared_dt, seconds, :seconds)

      assert datetime.minute == shared_dt.minute + 1
      assert datetime.second == 4
    end

    test "should add only minutes", %{datetime: shared_dt} do
      seconds = 120
      datetime = Momento.add(shared_dt, seconds, :seconds)

      assert datetime.minute == shared_dt.minute + 2
      assert datetime.second == shared_dt.second
    end
  end

  describe "milliseconds" do
    setup do
      %{datetime: %DateTime{Momento.date!() | second: 15, microsecond: {123_456, 6}}}
    end

    test "should map singular to plural", %{datetime: shared_dt} do
      milliseconds = 0
      datetime = Momento.add(shared_dt, milliseconds, :millisecond)

      assert datetime == shared_dt
    end

    test "should add nothing", %{datetime: shared_dt} do
      milliseconds = 0
      datetime = Momento.add(shared_dt, milliseconds, :milliseconds)

      assert datetime == shared_dt
    end

    test "should add milliseconds without rollover", %{datetime: shared_dt} do
      milliseconds = 100
      datetime = Momento.add(shared_dt, milliseconds, :milliseconds)
      {old_microsecond, old_precision} = shared_dt.microsecond
      {new_microsecond, new_precision} = datetime.microsecond

      assert new_microsecond == old_microsecond + milliseconds * 1000
      assert new_precision == old_precision
      assert datetime.second == shared_dt.second
    end

    test "should add milliseconds and rollover seconds", %{datetime: shared_dt} do
      milliseconds = 2111
      datetime = Momento.add(shared_dt, milliseconds, :milliseconds)
      {old_microsecond, old_precision} = shared_dt.microsecond
      {new_microsecond, new_precision} = datetime.microsecond

      assert new_microsecond == old_microsecond + 111_000
      assert new_precision == old_precision
      assert datetime.second == shared_dt.second + 2
    end

    test "should only add seconds", %{datetime: shared_dt} do
      milliseconds = 2000
      datetime = Momento.add(shared_dt, milliseconds, :milliseconds)

      assert datetime.microsecond == shared_dt.microsecond
      assert datetime.second == shared_dt.second + 2
    end
  end

  describe "microseconds" do
    setup do
      %{datetime: %DateTime{Momento.date!() | second: 15, microsecond: {123_456, 6}}}
    end

    test "should map singular to plural", %{datetime: shared_dt} do
      microseconds = 0
      datetime = Momento.add(shared_dt, microseconds, :microsecond)

      assert datetime == shared_dt
    end

    test "should add nothing", %{datetime: shared_dt} do
      microseconds = 0
      datetime = Momento.add(shared_dt, microseconds, :microseconds)

      assert datetime == shared_dt
    end

    test "should add microseconds without rollover", %{datetime: shared_dt} do
      microseconds = 111
      datetime = Momento.add(shared_dt, microseconds, :microseconds)
      {old_microsecond, old_precision} = shared_dt.microsecond
      {new_microsecond, new_precision} = datetime.microsecond

      assert new_microsecond == old_microsecond + microseconds
      assert new_precision == old_precision
    end

    test "should add microseconds and rollover seconds", %{datetime: shared_dt} do
      microseconds = 2_111_111
      datetime = Momento.add(shared_dt, microseconds, :microseconds)
      {old_microsecond, old_precision} = shared_dt.microsecond
      {new_microsecond, new_precision} = datetime.microsecond

      assert new_microsecond == old_microsecond + 111_111
      assert new_precision == old_precision
    end

    test "should only add seconds", %{datetime: shared_dt} do
      microseconds = 2_000_000
      datetime = Momento.add(shared_dt, microseconds, :microseconds)
      {old_microsecond, old_precision} = shared_dt.microsecond
      {new_microsecond, new_precision} = datetime.microsecond

      assert new_microsecond == old_microsecond
      assert new_precision == old_precision
      assert datetime.second == shared_dt.second + 2
    end
  end
end
