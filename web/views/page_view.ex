defmodule ShowTheMess.PageView do
  use ShowTheMess.Web, :view

  def key primary_key do
    primary_key |> String.replace("-","_") |> String.to_atom()
  end

  def fields entities, primary_key do
    map = entities |> List.first
    if map do
      key = key(primary_key)
      map
      |> Map.keys
      |> Enum.filter(&(&1 != :__struct__ and &1 != key))
      |> Enum.sort
      |> Enum.join(" ")
    else
      ""
    end
  end

end
