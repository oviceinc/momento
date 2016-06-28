defmodule Momento.Add do
  import Momento.Guards

  # Singular to plural
  def add(datetime, num, :year), do: add(datetime, num, :years)
  def add(datetime, num, :month), do: add(datetime, num, :months)
  def add(datetime, num, :day), do: add(datetime, num, :days)
  def add(datetime, num, :hour), do: add(datetime, num, :hours)
  def add(datetime, num, :minute), do: add(datetime, num, :minutes)
  def add(datetime, num, :second), do: add(datetime, num, :seconds)

  # Years
  def add(%DateTime{} = datetime, 0, :years), do: datetime
  def add(%DateTime{year: year} = datetime, num, :years) when positive?(num), do: %DateTime{datetime | year: year + num}


  # Months
  def add(%DateTime{} = datetime, 0, :months), do: datetime

  def add(%DateTime{year: year} = datetime, num, :months)
  when positive?(num) and num >= 12,
  do: add(%DateTime{datetime | year: year + 1}, num - 12, :month)

  def add(%DateTime{month: month} = datetime, num, :months)
  when positive?(num) and month + num <= 12,
  do: %DateTime{datetime | month: month + num}

  def add(%DateTime{year: year, month: month} = datetime, num, :months)
  when positive?(num) and month + num > 12,
  do: %DateTime{datetime | month: month + num - 12, year: year + 1}


  # Days
  def add(%DateTime{} = datetime, 0, :days), do: datetime

  def add(%DateTime{month: month, day: day} = datetime, num, :days)
  when positive?(num) and day + num <= days_in_month(month),
  do: %DateTime{datetime | day: day + num}

  def add(%DateTime{month: month} = datetime, num, :days)
  when positive?(num) and num >= days_in_month(month),
  do: add(datetime, 1, :months) |> add(num - days_in_month(month), :days)

  def add(%DateTime{month: month, day: day} = datetime, num, :days)
  when positive?(num) and day + num > days_in_month(month),
  do: add(add(%DateTime{datetime | day: 1}, 1, :months), -1 * (days_in_month(month) - day - num + 1), :days)






















  # Hours
  def add(%DateTime{} = datetime, 0, :hour), do: datetime
  def add(%DateTime{} = datetime, 0, :hours), do: add(datetime, 0, :hour)

  def add(%DateTime{hour: hour} = datetime, num, :hour)
  when positive?(num) and num + hour < 24,
  do: %{datetime | hour: num + hour}

  # def add(%DateTime{} = datetime, num, :hours)
  # when positive?(num) and num + hour < 24,
  # do: add(datetime, num, :hour)

  def add(%DateTime{hour: hour, day: day} = datetime, num, :hour)
  when positive?(num) and num + hour >= 24,
  do: add(%{datetime | day: day + 1}, num - 24, :hour)

  # def add(%DateTime{} = datetime, num, :hours)
  # when positive?(num) and num + hour >= 24,
  # do: add(datetime, num, :hour)

end
