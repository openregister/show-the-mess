defmodule ShowTheMess.PageView do
  use ShowTheMess.Web, :view

  def key(value) when is_atom(value), do: value
  def key(value) when is_binary(value) do
    value |> String.replace("-","_") |> String.to_atom()
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

  def records data_list_by_id do
    data_list_by_id
    |> Map.values
    |> Enum.map(&List.first/1)
  end

  def match_from_list list, code, primary_key do
    key = key(primary_key)
    list
    |> Enum.find(& Map.get(&1, key) == code)
  end

  def item_label(nil, file, name, maps_index), do: nil
  def item_label item, file, name, maps_index do
    code = maps_index[file]["key"]
    try do
      [lists_code_for(item, file, maps_index), lists_name_for(item, name, code)]
      |> Enum.filter(&(&1))
      |> Enum.uniq()
      |> Enum.join(" <br /> ")
    rescue
      KeyError -> ""
    end
  end

  def lists_code_for(nil, file, maps_index), do: nil
  def lists_code_for item, file, maps_index do
    Map.get item, key(maps_index[file]["key"])
  end

  defp normalise name do
    name |> String.downcase
  end

  def lists_name_for(nil, name, code), do: nil
  def lists_name_for item, name, code do
    item_name = try do
                  item.name
                rescue
                  KeyError -> item |> Map.get(key(code))
                  UndefinedFunctionError -> item |> Map.get(key(code))
                end
    if item_name == normalise(name) do
      nil
    else
      item_name
    end
  end

end
