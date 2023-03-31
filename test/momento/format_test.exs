defmodule Momento.FormatTest do
  use ExUnit.Case, async: true

  require Momento

  describe "years" do
    setup do
      %{datetime: %DateTime{Momento.date!() | year: 2016}}
    end

    test "should replace the YYYY token with a four digit year", %{datetime: shared_dt} do
      assert Momento.format(shared_dt, "YYYY") == "2016"
    end

    test "should replace the YY token with with a two digit year padded with a zero",
         %{datetime: shared_dt} do
      assert Momento.format(shared_dt, "YY") == "16"
    end
  end

  describe "months" do
    setup do
      %{datetime: %DateTime{Momento.date!() | month: 5}}
    end

    test "should replace the MMMM token with the full month name" do
      assert Momento.format(%DateTime{Momento.date!() | month: 1}, "MMMM") == "January"
      assert Momento.format(%DateTime{Momento.date!() | month: 2}, "MMMM") == "February"
      assert Momento.format(%DateTime{Momento.date!() | month: 3}, "MMMM") == "March"
      assert Momento.format(%DateTime{Momento.date!() | month: 4}, "MMMM") == "April"
      assert Momento.format(%DateTime{Momento.date!() | month: 5}, "MMMM") == "May"
      assert Momento.format(%DateTime{Momento.date!() | month: 6}, "MMMM") == "June"
      assert Momento.format(%DateTime{Momento.date!() | month: 7}, "MMMM") == "July"
      assert Momento.format(%DateTime{Momento.date!() | month: 8}, "MMMM") == "August"
      assert Momento.format(%DateTime{Momento.date!() | month: 9}, "MMMM") == "September"
      assert Momento.format(%DateTime{Momento.date!() | month: 10}, "MMMM") == "October"
      assert Momento.format(%DateTime{Momento.date!() | month: 11}, "MMMM") == "November"
      assert Momento.format(%DateTime{Momento.date!() | month: 12}, "MMMM") == "December"
    end

    test "should replace the MMM token with the month abbreviation" do
      assert Momento.format(%DateTime{Momento.date!() | month: 1}, "MMM") == "Jan"
      assert Momento.format(%DateTime{Momento.date!() | month: 2}, "MMM") == "Feb"
      assert Momento.format(%DateTime{Momento.date!() | month: 3}, "MMM") == "Mar"
      assert Momento.format(%DateTime{Momento.date!() | month: 4}, "MMM") == "Apr"
      assert Momento.format(%DateTime{Momento.date!() | month: 5}, "MMM") == "May"
      assert Momento.format(%DateTime{Momento.date!() | month: 6}, "MMM") == "Jun"
      assert Momento.format(%DateTime{Momento.date!() | month: 7}, "MMM") == "Jul"
      assert Momento.format(%DateTime{Momento.date!() | month: 8}, "MMM") == "Aug"
      assert Momento.format(%DateTime{Momento.date!() | month: 9}, "MMM") == "Sep"
      assert Momento.format(%DateTime{Momento.date!() | month: 10}, "MMM") == "Oct"
      assert Momento.format(%DateTime{Momento.date!() | month: 11}, "MMM") == "Nov"
      assert Momento.format(%DateTime{Momento.date!() | month: 12}, "MMM") == "Dec"
    end

    test "should replace the MM token with two digit month of year padded with a zero",
         %{datetime: shared_dt} do
      assert Momento.format(shared_dt, "MM") == "05"
    end

    test "should replace the Mo token with month of year ordinal" do
      assert Momento.format(%DateTime{Momento.date!() | month: 1}, "Mo") == "1st"
      assert Momento.format(%DateTime{Momento.date!() | month: 2}, "Mo") == "2nd"
      assert Momento.format(%DateTime{Momento.date!() | month: 3}, "Mo") == "3rd"
      assert Momento.format(%DateTime{Momento.date!() | month: 4}, "Mo") == "4th"
      assert Momento.format(%DateTime{Momento.date!() | month: 5}, "Mo") == "5th"
      assert Momento.format(%DateTime{Momento.date!() | month: 6}, "Mo") == "6th"
      assert Momento.format(%DateTime{Momento.date!() | month: 7}, "Mo") == "7th"
      assert Momento.format(%DateTime{Momento.date!() | month: 8}, "Mo") == "8th"
      assert Momento.format(%DateTime{Momento.date!() | month: 9}, "Mo") == "9th"
      assert Momento.format(%DateTime{Momento.date!() | month: 10}, "Mo") == "10th"
      assert Momento.format(%DateTime{Momento.date!() | month: 11}, "Mo") == "11th"
      assert Momento.format(%DateTime{Momento.date!() | month: 12}, "Mo") == "12th"
    end

    test "should replace the M token with month of year without zero padding",
         %{datetime: shared_dt} do
      assert Momento.format(shared_dt, "M") == "5"
    end
  end

  describe "days" do
    setup do
      %{datetime: %DateTime{Momento.date!() | day: 5}}
    end

    test "should replace the DD token with day of month padded with a zero",
         %{datetime: shared_dt} do
      assert Momento.format(shared_dt, "DD") == "05"
    end

    test "should replace the Do token with day of month ordinal", %{datetime: shared_dt} do
      assert Momento.format(shared_dt, "Do") == "5th"
      assert Momento.format(%DateTime{Momento.date!() | day: 1}, "Do") == "1st"
      assert Momento.format(%DateTime{Momento.date!() | day: 2}, "Do") == "2nd"
      assert Momento.format(%DateTime{Momento.date!() | day: 3}, "Do") == "3rd"
      assert Momento.format(%DateTime{Momento.date!() | day: 12}, "Do") == "12th"
      assert Momento.format(%DateTime{Momento.date!() | day: 31}, "Do") == "31st"
    end

    test "should replace the D token with day of month without zero padding",
         %{datetime: shared_dt} do
      assert Momento.format(shared_dt, "D") == "5"
    end
  end

  describe "day of the week" do
    setup do
      %{
        sunday: %DateTime{Momento.date!() | day: 29, month: 2, year: 2004},
        monday: %DateTime{Momento.date!() | day: 22, month: 3, year: 1993},
        tuesday: %DateTime{Momento.date!() | day: 5, month: 12, year: 2023},
        wednesday: %DateTime{Momento.date!() | day: 20, month: 8, year: 2003},
        thursday: %DateTime{Momento.date!() | day: 25, month: 1, year: 1996},
        friday: %DateTime{Momento.date!() | day: 22, month: 4, year: 2016},
        saturday: %DateTime{Momento.date!() | day: 9, month: 6, year: 2007}
      }
    end

    test "should replace the dddd token with day of week full name", %{
      sunday: sunday,
      monday: monday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday
    } do
      assert Momento.format(sunday, "dddd") == "Sunday"
      assert Momento.format(monday, "dddd") == "Monday"
      assert Momento.format(tuesday, "dddd") == "Tuesday"
      assert Momento.format(wednesday, "dddd") == "Wednesday"
      assert Momento.format(thursday, "dddd") == "Thursday"
      assert Momento.format(friday, "dddd") == "Friday"
      assert Momento.format(saturday, "dddd") == "Saturday"
    end

    test "should replace the ddd token with day of week three letter abbreviation", %{
      sunday: sunday,
      monday: monday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday
    } do
      assert Momento.format(sunday, "ddd") == "Sun"
      assert Momento.format(monday, "ddd") == "Mon"
      assert Momento.format(tuesday, "ddd") == "Tue"
      assert Momento.format(wednesday, "ddd") == "Wed"
      assert Momento.format(thursday, "ddd") == "Thu"
      assert Momento.format(friday, "ddd") == "Fri"
      assert Momento.format(saturday, "ddd") == "Sat"
    end

    test "should replace the dd token with day of week two letter abbreviation", %{
      sunday: sunday,
      monday: monday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday
    } do
      assert Momento.format(sunday, "dd") == "Su"
      assert Momento.format(monday, "dd") == "Mo"
      assert Momento.format(tuesday, "dd") == "Tu"
      assert Momento.format(wednesday, "dd") == "We"
      assert Momento.format(thursday, "dd") == "Th"
      assert Momento.format(friday, "dd") == "Fr"
      assert Momento.format(saturday, "dd") == "Sa"
    end

    test "should replace the do token with day of week ordinal zero indexed in ordinal form", %{
      sunday: sunday,
      monday: monday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday
    } do
      assert Momento.format(sunday, "do") == "0th"
      assert Momento.format(monday, "do") == "1st"
      assert Momento.format(tuesday, "do") == "2nd"
      assert Momento.format(wednesday, "do") == "3rd"
      assert Momento.format(thursday, "do") == "4th"
      assert Momento.format(friday, "do") == "5th"
      assert Momento.format(saturday, "do") == "6th"
    end

    test "should replace the d token with day of week zero indexed", %{
      sunday: sunday,
      monday: monday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday
    } do
      assert Momento.format(sunday, "d") == "0"
      assert Momento.format(monday, "d") == "1"
      assert Momento.format(tuesday, "d") == "2"
      assert Momento.format(wednesday, "d") == "3"
      assert Momento.format(thursday, "d") == "4"
      assert Momento.format(friday, "d") == "5"
      assert Momento.format(saturday, "d") == "6"
    end
  end

  describe "hours" do
    setup do
      %{datetime: %DateTime{Momento.date!() | hour: 5}}
    end

    test "should replace the HH token with two digit hour of day padded with a zero", %{
      datetime: shared_dt
    } do
      assert Momento.format(shared_dt, "HH") == "05"
    end

    test "should replace the H token with hour of day without zero padding", %{
      datetime: shared_dt
    } do
      assert Momento.format(shared_dt, "H") == "5"
    end

    test "should replace the hh token with hour of day in 12 hour format padded with a zero" do
      assert Momento.format(%DateTime{Momento.date!() | hour: 0}, "hh") == "12"
      assert Momento.format(%DateTime{Momento.date!() | hour: 1}, "hh") == "01"
      assert Momento.format(%DateTime{Momento.date!() | hour: 4}, "hh") == "04"
      assert Momento.format(%DateTime{Momento.date!() | hour: 8}, "hh") == "08"
      assert Momento.format(%DateTime{Momento.date!() | hour: 11}, "hh") == "11"
      assert Momento.format(%DateTime{Momento.date!() | hour: 12}, "hh") == "12"
      assert Momento.format(%DateTime{Momento.date!() | hour: 13}, "hh") == "01"
      assert Momento.format(%DateTime{Momento.date!() | hour: 14}, "hh") == "02"
      assert Momento.format(%DateTime{Momento.date!() | hour: 18}, "hh") == "06"
      assert Momento.format(%DateTime{Momento.date!() | hour: 21}, "hh") == "09"
      assert Momento.format(%DateTime{Momento.date!() | hour: 23}, "hh") == "11"
      assert Momento.format(%DateTime{Momento.date!() | hour: 24}, "hh") == "12"
    end

    test "should replace the h token with hour of day in 12 hour format without zero padding" do
      assert Momento.format(%DateTime{Momento.date!() | hour: 0}, "h") == "12"
      assert Momento.format(%DateTime{Momento.date!() | hour: 1}, "h") == "1"
      assert Momento.format(%DateTime{Momento.date!() | hour: 3}, "h") == "3"
      assert Momento.format(%DateTime{Momento.date!() | hour: 7}, "h") == "7"
      assert Momento.format(%DateTime{Momento.date!() | hour: 11}, "h") == "11"
      assert Momento.format(%DateTime{Momento.date!() | hour: 12}, "h") == "12"
      assert Momento.format(%DateTime{Momento.date!() | hour: 13}, "h") == "1"
      assert Momento.format(%DateTime{Momento.date!() | hour: 15}, "h") == "3"
      assert Momento.format(%DateTime{Momento.date!() | hour: 19}, "h") == "7"
      assert Momento.format(%DateTime{Momento.date!() | hour: 22}, "h") == "10"
      assert Momento.format(%DateTime{Momento.date!() | hour: 23}, "h") == "11"
      assert Momento.format(%DateTime{Momento.date!() | hour: 24}, "h") == "12"
    end
  end

  describe "minutes" do
    setup do
      %{datetime: %DateTime{Momento.date!() | minute: 5}}
    end

    test "should replace the mm token with two digit minute of hour padded with a zero",
         %{datetime: shared_dt} do
      assert Momento.format(shared_dt, "mm") == "05"
    end

    test "should replace the m token with minute of hour without zero padding",
         %{datetime: shared_dt} do
      assert Momento.format(shared_dt, "m") == "5"
    end
  end

  describe "seconds" do
    setup do
      %{datetime: %DateTime{Momento.date!() | second: 5}}
    end

    test "should replace the mm token with two digit second of minute padded with a zero",
         %{datetime: shared_dt} do
      assert Momento.format(shared_dt, "ss") == "05"
    end

    test "should replace the m token with second of minute without zero padding",
         %{datetime: shared_dt} do
      assert Momento.format(shared_dt, "s") == "5"
    end
  end

  describe "am / pm" do
    test "should replace the A token with AM/PM" do
      assert Momento.format(%DateTime{Momento.date!() | hour: 0}, "A") == "AM"
      assert Momento.format(%DateTime{Momento.date!() | hour: 6}, "A") == "AM"
      assert Momento.format(%DateTime{Momento.date!() | hour: 11}, "A") == "AM"
      assert Momento.format(%DateTime{Momento.date!() | hour: 12}, "A") == "PM"
      assert Momento.format(%DateTime{Momento.date!() | hour: 13}, "A") == "PM"
      assert Momento.format(%DateTime{Momento.date!() | hour: 24}, "A") == "PM"
    end

    test "should replace the a token with am/pm" do
      assert Momento.format(%DateTime{Momento.date!() | hour: 0}, "a") == "am"
      assert Momento.format(%DateTime{Momento.date!() | hour: 6}, "a") == "am"
      assert Momento.format(%DateTime{Momento.date!() | hour: 11}, "a") == "am"
      assert Momento.format(%DateTime{Momento.date!() | hour: 12}, "a") == "pm"
      assert Momento.format(%DateTime{Momento.date!() | hour: 13}, "a") == "pm"
      assert Momento.format(%DateTime{Momento.date!() | hour: 24}, "a") == "pm"
    end
  end

  describe "quarter" do
    setup do
      %{
        quarter_one_begin: %DateTime{Momento.date!() | month: 1},
        quarter_one_end: %DateTime{Momento.date!() | month: 3},
        quarter_two_begin: %DateTime{Momento.date!() | month: 4},
        quarter_two_end: %DateTime{Momento.date!() | month: 6},
        quarter_three_begin: %DateTime{Momento.date!() | month: 7},
        quarter_three_end: %DateTime{Momento.date!() | month: 9},
        quarter_four_begin: %DateTime{Momento.date!() | month: 10},
        quarter_four_end: %DateTime{Momento.date!() | month: 12}
      }
    end

    test "should replace the Q token with quarter of year non-zero indexed", %{
      quarter_one_begin: quarter_one_begin,
      quarter_one_end: quarter_one_end,
      quarter_two_begin: quarter_two_begin,
      quarter_two_end: quarter_two_end,
      quarter_three_begin: quarter_three_begin,
      quarter_three_end: quarter_three_end,
      quarter_four_begin: quarter_four_begin,
      quarter_four_end: quarter_four_end
    } do
      assert Momento.format(quarter_one_begin, "Q") == "1"
      assert Momento.format(quarter_one_end, "Q") == "1"
      assert Momento.format(quarter_two_begin, "Q") == "2"
      assert Momento.format(quarter_two_end, "Q") == "2"
      assert Momento.format(quarter_three_begin, "Q") == "3"
      assert Momento.format(quarter_three_end, "Q") == "3"
      assert Momento.format(quarter_four_begin, "Q") == "4"
      assert Momento.format(quarter_four_end, "Q") == "4"
    end

    test "should replace the Qo token with quarter of year non-zero indexed ordinal", %{
      quarter_one_begin: quarter_one_begin,
      quarter_one_end: quarter_one_end,
      quarter_two_begin: quarter_two_begin,
      quarter_two_end: quarter_two_end,
      quarter_three_begin: quarter_three_begin,
      quarter_three_end: quarter_three_end,
      quarter_four_begin: quarter_four_begin,
      quarter_four_end: quarter_four_end
    } do
      assert Momento.format(quarter_one_begin, "Qo") == "1st"
      assert Momento.format(quarter_one_end, "Qo") == "1st"
      assert Momento.format(quarter_two_begin, "Qo") == "2nd"
      assert Momento.format(quarter_two_end, "Qo") == "2nd"
      assert Momento.format(quarter_three_begin, "Qo") == "3rd"
      assert Momento.format(quarter_three_end, "Qo") == "3rd"
      assert Momento.format(quarter_four_begin, "Qo") == "4th"
      assert Momento.format(quarter_four_end, "Qo") == "4th"
    end
  end

  describe "unix epoch" do
    setup do
      %{
        datetime: %DateTime{
          Momento.date!()
          | year: 2016,
            month: 7,
            day: 1,
            hour: 12,
            minute: 0,
            second: 5,
            microsecond: {0, 6}
        }
      }
    end

    test "should replace the X token with unix time in seconds", %{datetime: shared_dt} do
      assert Momento.format(shared_dt, "X") == "1467374405"
    end

    test "should replace the x token with unix time in seconds", %{datetime: shared_dt} do
      assert Momento.format(shared_dt, "x") == "1467374405000"
    end
  end

  describe "unknown" do
    setup do
      %{datetime: %DateTime{Momento.date!() | year: 2016, month: 7, day: 6}}
    end

    test "should keep unknown tokens", %{datetime: shared_dt} do
      assert Momento.format(shared_dt, "YYYY-MM-DD") == "2016-07-06"
    end
  end

  describe "localized formats" do
    setup do
      %{
        # Thursday May 29, 1997
        day_one: %DateTime{
          Momento.date!()
          | day: 29,
            month: 5,
            year: 1997,
            hour: 15,
            minute: 22,
            second: 34
        },
        # Friday April 1 2011
        day_two: %DateTime{
          Momento.date!()
          | day: 1,
            month: 4,
            year: 2011,
            hour: 12,
            minute: 0,
            second: 1
        },
        # Sunday Feb 29 2004
        day_three: %DateTime{
          Momento.date!()
          | day: 29,
            month: 2,
            year: 2004,
            hour: 6,
            minute: 12,
            second: 59
        },
        # Monday July 25 2016
        day_four: %DateTime{
          Momento.date!()
          | day: 25,
            month: 7,
            year: 2016,
            hour: 23,
            minute: 45,
            second: 45
        },
        # Wednesday Nov 22 2028
        day_five: %DateTime{
          Momento.date!()
          | day: 22,
            month: 11,
            year: 2028,
            hour: 3,
            minute: 51,
            second: 21
        }
      }
    end

    test "should replace the LLLL token with day of week, full month, day of month, year and 12 hour formatted time",
         %{
           day_one: day_one,
           day_two: day_two,
           day_three: day_three,
           day_four: day_four,
           day_five: day_five
         } do
      assert Momento.format(day_one, "LLLL") == "Thursday, May 29 1997 3:22 PM"
      assert Momento.format(day_two, "LLLL") == "Friday, April 1 2011 12:00 PM"
      assert Momento.format(day_three, "LLLL") == "Sunday, February 29 2004 6:12 AM"
      assert Momento.format(day_four, "LLLL") == "Monday, July 25 2016 11:45 PM"
      assert Momento.format(day_five, "LLLL") == "Wednesday, November 22 2028 3:51 AM"
    end

    test "should replace the LLL token with Month name, day of month, year, 12 hour formatted time",
         %{
           day_one: day_one,
           day_two: day_two,
           day_three: day_three,
           day_four: day_four,
           day_five: day_five
         } do
      assert Momento.format(day_one, "LLL") == "May 29 1997 3:22 PM"
      assert Momento.format(day_two, "LLL") == "April 1 2011 12:00 PM"
      assert Momento.format(day_three, "LLL") == "February 29 2004 6:12 AM"
      assert Momento.format(day_four, "LLL") == "July 25 2016 11:45 PM"
      assert Momento.format(day_five, "LLL") == "November 22 2028 3:51 AM"
    end

    test "should replace the LL token with full month, day of month and year", %{
      day_one: day_one,
      day_two: day_two,
      day_three: day_three,
      day_four: day_four,
      day_five: day_five
    } do
      assert Momento.format(day_one, "LL") == "May 29 1997"
      assert Momento.format(day_two, "LL") == "April 1 2011"
      assert Momento.format(day_three, "LL") == "February 29 2004"
      assert Momento.format(day_four, "LL") == "July 25 2016"
      assert Momento.format(day_five, "LL") == "November 22 2028"
    end

    test "should replace the LTS token with 12 hour formatted time with seconds", %{
      day_one: day_one,
      day_two: day_two,
      day_three: day_three,
      day_four: day_four,
      day_five: day_five
    } do
      assert Momento.format(day_one, "LTS") == "3:22:34 PM"
      assert Momento.format(day_two, "LTS") == "12:00:01 PM"
      assert Momento.format(day_three, "LTS") == "6:12:59 AM"
      assert Momento.format(day_four, "LTS") == "11:45:45 PM"
      assert Momento.format(day_five, "LTS") == "3:51:21 AM"
    end

    test "should replace the LT token with 12 hour formatted time", %{
      day_one: day_one,
      day_two: day_two,
      day_three: day_three,
      day_four: day_four,
      day_five: day_five
    } do
      assert Momento.format(day_one, "LT") == "3:22 PM"
      assert Momento.format(day_two, "LT") == "12:00 PM"
      assert Momento.format(day_three, "LT") == "6:12 AM"
      assert Momento.format(day_four, "LT") == "11:45 PM"
      assert Momento.format(day_five, "LT") == "3:51 AM"
    end

    test "should replace the L token with month numeral, day of month, year", %{
      day_one: day_one,
      day_two: day_two,
      day_three: day_three,
      day_four: day_four,
      day_five: day_five
    } do
      assert Momento.format(day_one, "L") == "05/29/1997"
      assert Momento.format(day_two, "L") == "04/01/2011"
      assert Momento.format(day_three, "L") == "02/29/2004"
      assert Momento.format(day_four, "L") == "07/25/2016"
      assert Momento.format(day_five, "L") == "11/22/2028"
    end

    test "should replace the llll token with day of week abbreviated, day of month abbreviated, year and 12 hour formatted time",
         %{
           day_one: day_one,
           day_two: day_two,
           day_three: day_three,
           day_four: day_four,
           day_five: day_five
         } do
      assert Momento.format(day_one, "llll") == "Thu, May 29 1997 3:22 PM"
      assert Momento.format(day_two, "llll") == "Fri, Apr 1 2011 12:00 PM"
      assert Momento.format(day_three, "llll") == "Sun, Feb 29 2004 6:12 AM"
      assert Momento.format(day_four, "llll") == "Mon, Jul 25 2016 11:45 PM"
      assert Momento.format(day_five, "llll") == "Wed, Nov 22 2028 3:51 AM"
    end

    test "should replace the lll token with abbreviated month, day of month, year and 12 hour formatted time",
         %{
           day_one: day_one,
           day_two: day_two,
           day_three: day_three,
           day_four: day_four,
           day_five: day_five
         } do
      assert Momento.format(day_one, "lll") == "May 29 1997 3:22 PM"
      assert Momento.format(day_two, "lll") == "Apr 1 2011 12:00 PM"
      assert Momento.format(day_three, "lll") == "Feb 29 2004 6:12 AM"
      assert Momento.format(day_four, "lll") == "Jul 25 2016 11:45 PM"
      assert Momento.format(day_five, "lll") == "Nov 22 2028 3:51 AM"
    end

    test "should replace the ll token with abbreviated month, day of month and year", %{
      day_one: day_one,
      day_two: day_two,
      day_three: day_three,
      day_four: day_four,
      day_five: day_five
    } do
      assert Momento.format(day_one, "ll") == "May 29 1997"
      assert Momento.format(day_two, "ll") == "Apr 1 2011"
      assert Momento.format(day_three, "ll") == "Feb 29 2004"
      assert Momento.format(day_four, "ll") == "Jul 25 2016"
      assert Momento.format(day_five, "ll") == "Nov 22 2028"
    end

    test "should replace the l token with abbreviated numeral, day of month, year", %{
      day_one: day_one,
      day_two: day_two,
      day_three: day_three,
      day_four: day_four,
      day_five: day_five
    } do
      assert Momento.format(day_one, "l") == "5/29/1997"
      assert Momento.format(day_two, "l") == "4/1/2011"
      assert Momento.format(day_three, "l") == "2/29/2004"
      assert Momento.format(day_four, "l") == "7/25/2016"
      assert Momento.format(day_five, "l") == "11/22/2028"
    end
  end
end
