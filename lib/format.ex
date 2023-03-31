defmodule Momento.Format do
  @moduledoc """
  This module holds all the `format/2` method.
  """

  @doc """
  Provide a `DateTime` struct and token string to get back a formatted date/datetime string.

  ## Examples

      iex> Momento.date |> Momento.format("YYYY-MM-DD")
      "2016-07-01"

      ...> Momento.date |> Momento.format("M-D-YY")
      "7-1-16"
  """

  @tokens ~r/A|a|YYYY|YY?|Mo|MM?M?M?|Do|do|DD?D?D?|dd?d?d?|HH?|hh?|LTS?|LL?L?L?|ll?l?l?|mm?|Qo|Q|ss?|X|x/

  @spec format(DateTime.t(), String.t()) :: String.t()
  # An implementation of the Moment.js formats listed here: http://momentjs.com/docs/#/displaying/format/
  # TODO: Add support for escaping characters within square brackets []
  def format(%DateTime{} = datetime, format_string)
      when is_bitstring(format_string) do
    # Split the format_string into pieces by tokens
    Regex.split(@tokens, format_string, include_captures: true, trim: true)
    # Convert each token
    |> Enum.map_join(&evaluate(&1, datetime))
  end

  defp calculate_day_of_the_week(datetime) do
    month_offsets = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4}

    year = if datetime.month < 3, do: datetime.year - 1, else: datetime.year

    (year + div(year, 4) - div(year, 100) + div(year, 400) +
       elem(month_offsets, datetime.month - 1) + datetime.day)
    |> rem(7)
  end

  defp get_am_pm(hour, token \\ :A) do
    am_pm = if hour >= 12, do: "PM", else: "AM"

    case token do
      :a -> String.downcase(am_pm)
      _ -> am_pm
    end
  end

  defp get_day_of_the_week(datetime, token \\ :d) do
    days_of_a_week =
      {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}

    integer_day_of_the_week = calculate_day_of_the_week(datetime)

    case token do
      :dddd -> elem(days_of_a_week, integer_day_of_the_week)
      :ddd -> elem(days_of_a_week, integer_day_of_the_week) |> String.slice(0..2)
      :dd -> elem(days_of_a_week, integer_day_of_the_week) |> String.slice(0..1)
      :do -> get_ordinal_form(integer_day_of_the_week)
      _ -> integer_day_of_the_week |> Integer.to_string()
    end
  end

  defp get_month_name(month_number, token \\ :MMMM) do
    month_name =
      elem(
        {"January", "February", "March", "April", "May", "June", "July", "August", "September",
         "October", "November", "December"},
        month_number - 1
      )

    case token do
      :MMM -> String.slice(month_name, 0..2)
      _ -> month_name
    end
  end

  defp get_ordinal_form(number) do
    number_rem_hundred = rem(number, 100)

    ordinal_form =
      if number_rem_hundred == 11 || number_rem_hundred == 12 || number_rem_hundred == 13 do
        "th"
      else
        number_rem_ten = rem(number, 10)

        cond do
          number_rem_ten == 1 -> "st"
          number_rem_ten == 2 -> "nd"
          number_rem_ten == 3 -> "rd"
          true -> "th"
        end
      end

    Integer.to_string(number) <> ordinal_form
  end

  defp get_quarter(month, token \\ :Q) do
    quarter = month_to_quarter(month)

    case token do
      :Qo -> get_ordinal_form(quarter)
      _ -> Integer.to_string(quarter)
    end
  end

  defp month_to_quarter(m) when m in 1..3, do: 1
  defp month_to_quarter(m) when m in 4..6, do: 2
  defp month_to_quarter(m) when m in 7..9, do: 3
  defp month_to_quarter(m) when m in 10..12, do: 4
  defp month_to_quarter(m), do: raise(ArgumentError, "invalid month: #{m}")

  defp twelve_hour_format(hour, token \\ :h) do
    adjusted_hour =
      cond do
        hour >= 13 -> hour - 12
        hour == 0 -> 12
        true -> hour
      end

    adjusted_hour = Integer.to_string(adjusted_hour)

    case token do
      :hh -> adjusted_hour |> String.pad_leading(2, "0")
      _ -> adjusted_hour
    end
  end

  defp pad_leading_zero(number) do
    number |> Integer.to_string() |> String.pad_leading(2, "0")
  end

  # 1970 1971 ... 2029 2030
  defp evaluate("YYYY", datetime), do: datetime.year |> Integer.to_string()
  # 70 71 ... 29 30
  defp evaluate("YY", datetime), do: datetime.year |> Integer.to_string() |> String.slice(2..3)
  # TODO: 1970 1971 ... 9999 +10000 +10001
  # "Y" -> datetime.year |> Integer.to_string)

  # January February ... November December
  defp evaluate("MMMM", datetime), do: get_month_name(datetime.month)
  # Jan Feb ... Nov Dec
  defp evaluate("MMM", datetime), do: get_month_name(datetime.month, :MMM)

  # 01 02 ... 11 12
  defp evaluate("MM", datetime),
    do: datetime.month |> Integer.to_string() |> String.pad_leading(2, <<?0>>)

  # 1 2 ... 11 12
  defp evaluate("M", datetime), do: Integer.to_string(datetime.month)

  # 1st 2nd ... 11th 12th
  defp evaluate("Mo", datetime), do: get_ordinal_form(datetime.month)

  # TODO: 001 002 ... 364 365
  # "DDDD" -> datetime.day |> Integer.to_string

  # TODO: 1st 2nd ... 364th 365th
  # "DDDo" -> datetime.day |> Integer.to_string

  # TODO: 1 2 ... 364 365
  # "DDD" -> datetime.day |> Integer.to_string

  # 01 02 ... 30 31
  defp evaluate("DD", datetime),
    do: datetime.day |> Integer.to_string() |> String.pad_leading(2, <<?0>>)

  # 1st 2nd ... 30th 31st
  defp evaluate("Do", datetime), do: get_ordinal_form(datetime.day)

  # 1 2 ... 30 31
  defp evaluate("D", datetime), do: Integer.to_string(datetime.day)

  # Sunday Monday ... Friday Saturday
  defp evaluate("dddd", datetime), do: get_day_of_the_week(datetime, :dddd)

  # Sun Mon ... Fri Sat
  defp evaluate("ddd", datetime), do: get_day_of_the_week(datetime, :ddd)

  # Su Mo ... Fr Sa
  defp evaluate("dd", datetime), do: get_day_of_the_week(datetime, :dd)

  # 0th 1st ... 5th 6th
  defp evaluate("do", datetime), do: get_day_of_the_week(datetime, :do)

  # 0 1 ... 5 6
  defp evaluate("d", datetime), do: get_day_of_the_week(datetime)

  # 00 01 ... 22 23
  defp evaluate("HH", datetime),
    do: datetime.hour |> Integer.to_string() |> String.pad_leading(2, <<?0>>)

  # 0 1 ... 22 23
  defp evaluate("H", datetime), do: Integer.to_string(datetime.hour)

  # 01 02 ... 11 12
  defp evaluate("hh", datetime), do: twelve_hour_format(datetime.hour, :hh)

  # 1 2 ... 11 12
  defp evaluate("h", datetime), do: twelve_hour_format(datetime.hour)

  # TODO: 01 02 ... 23 24
  # "kk" -> datetime.hour |> Integer.to_string

  # TODO: 1 2 ... 23 24
  # "k" -> datetime.hour |> Integer.to_string

  # 00 01 ... 58 59
  defp evaluate("mm", datetime),
    do: datetime.minute |> Integer.to_string() |> String.pad_leading(2, <<?0>>)

  # 0 1 ... 58 59
  defp evaluate("m", datetime), do: Integer.to_string(datetime.minute)

  # 00 01 ... 58 59
  defp evaluate("ss", datetime),
    do: datetime.second |> Integer.to_string() |> String.pad_leading(2, <<?0>>)

  # 0 1 ... 58 59
  defp evaluate("s", datetime), do: Integer.to_string(datetime.second)

  # TODO: 000[0..] 001[0..] ... 998[0..] 999[0..]
  # ~r/S{4,9}/ -> datetime.second |> Integer.to_string

  # TODO: 000 001 ... 998 999
  # "SSS" -> datetime.second |> Integer.to_string

  # TODO: 00 01 ... 98 99
  # "SS" -> datetime.second |> Integer.to_string

  # TODO: 0 1 ... 8 9
  # "S" -> datetime.second |> Integer.to_string

  # TODO: -0700 -0600 ... +0600 +0700
  # "ZZ" -> datetime.time_zone

  # TODO: -07:00 -06:00 ... +06:00 +07:00
  # "Z" -> datetime.time_zone

  # AM PM
  defp evaluate("A", datetime), do: get_am_pm(datetime.hour)

  # am pm
  defp evaluate("a", datetime), do: get_am_pm(datetime.hour, :a)

  # 1 2 3 4
  defp evaluate("Q", datetime), do: get_quarter(datetime.month)

  # 1st 2nd 3rd 4th
  defp evaluate("Qo", datetime), do: get_quarter(datetime.month, :Qo)

  # TODO: 1 2 ... 6 7
  # "E" -> datetime

  # TODO: 0 1 ... 5 6
  # "e" -> datetime

  # TODO: 01 02 ... 52 53
  # "WW" -> datetime

  # TODO: 1st 2nd ... 52nd 53rd
  # "Wo" -> datetime

  # TODO: 1 2 ... 52 53
  # "W" -> datetime

  # TODO: 01 02 ... 52 53
  # "ww" -> datetime

  # TODO: 1st 2nd ... 52nd 53rd
  # "wo" -> datetime

  # TODO: 1 2 ... 52 53
  # "w" -> datetime

  # TODO: 1970 1971 ... 2029 2030
  # "GGGG" -> datetime

  # TODO: 70 71 ... 29 30
  # "GG" -> datetime

  # TODO: 1970 1971 ... 2029 2030
  # "gggg" -> datetime

  # TODO: 70 71 ... 29 30
  # "gg" -> datetime

  # Thursday, September 4 1986 8:30 PM
  defp evaluate("LLLL", datetime),
    do: Momento.format(datetime, "dddd, MMMM D YYYY h:#{pad_leading_zero(datetime.minute)} A")

  # Sep 4 1986 8:30 PM
  defp evaluate("LLL", datetime),
    do: Momento.format(datetime, "MMMM D YYYY h:#{pad_leading_zero(datetime.minute)} A")

  # September 4 1986
  defp evaluate("LL", datetime), do: Momento.format(datetime, "MMMM D YYYY")

  # 8:30:25 PM
  defp evaluate("LTS", datetime),
    do:
      Momento.format(
        datetime,
        "h:#{pad_leading_zero(datetime.minute)}:#{pad_leading_zero(datetime.second)} A"
      )

  # 8:30 PM
  defp evaluate("LT", datetime),
    do: Momento.format(datetime, "h:#{pad_leading_zero(datetime.minute)} A")

  # 09/04/1986
  defp evaluate("L", datetime), do: Momento.format(datetime, "MM/DD/YYYY")

  # Thu, Sep 4 1986 8:30 PM
  defp evaluate("llll", datetime),
    do: Momento.format(datetime, "ddd, MMM D YYYY h:#{pad_leading_zero(datetime.minute)} A")

  # Sep 4 1986 8:30 PM
  defp evaluate("lll", datetime),
    do: Momento.format(datetime, "MMM D YYYY h:#{pad_leading_zero(datetime.minute)} A")

  # Sep 4 1986
  defp evaluate("ll", datetime), do: Momento.format(datetime, "MMM D YYYY")

  # 9/4/1986
  defp evaluate("l", datetime), do: Momento.format(datetime, "M/D/YYYY")

  # 1360013296
  defp evaluate("X", datetime), do: datetime |> DateTime.to_unix() |> Integer.to_string()

  # 1360013296123
  defp evaluate("x", datetime),
    do: datetime |> DateTime.to_unix(:millisecond) |> Integer.to_string()

  defp evaluate(token, _), do: token
end
