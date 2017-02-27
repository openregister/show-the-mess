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

  def description maps_index, register do
    maps_value(maps_index, register, "description")
  end

  def maps_key maps_index, file do
    maps_value(maps_index, file, "key")
  end

  def maps_value maps_index, register, field do
    maps_index
    |> List.keyfind(register, 0)
    |> Tuple.to_list
    |> List.last
    |> Map.get(field)
  end

  def records data_list_by_id do
    data_list_by_id
    |> Map.values
    |> Enum.map(&List.first/1)
  end

  def link_key("local-authority-eng"), do: key("local-authority")
  def link_key(primary_key), do: key(primary_key)

  def match_code("local-authority-eng", code), do: "local-authority-eng:#{code}"
  def match_code(_, code), do: code

  def match_from_list list, code, primary_key do
    key = link_key(primary_key)
    code = match_code(primary_key, code)
    list
    |> Enum.find(& Map.get(&1, key) == code)
  end

  def item_label(nil, _, _, _), do: nil
  def item_label item, file, record_name, maps_index do
    code = key( maps_key(maps_index, file) )
    try do
      item_code = Map.get item, key( maps_key(maps_index, file) )
      item_code_display = lists_code_for(item, record_name, item_code, code, file, maps_index)
      [item_code_display, lists_name_for(item, record_name, code, item_code)]
      |> Enum.reject(& is_nil/1)
      |> Enum.join(" <br /> ")
    rescue
      KeyError -> ""
    end
  end

  def lists_code_for(nil, _, _, _, _, _), do: nil
  def lists_code_for item, record_name, item_code, code, file, maps_index do
    if normalise(item_code) == normalise(record_name) do
      "”"
    else
      if item_code == item_name(item, code) do
        "<b>" <> item_code <> "</b>"
      else
        item_code
      end
    end
  end

  defp normalise name do
    name |> String.downcase
  end

  defp item_name item, code do
    try do
      item.name
    rescue
      KeyError -> item |> Map.get(link_key(code))
      UndefinedFunctionError -> item |> Map.get(link_key(code))
    end
  end

  def lists_name_for(nil, _, _, _), do: nil
  def lists_name_for item, record_name, code, item_code do
    item_name = item_name(item, code)
    if normalise(item_name) == normalise(record_name) do
      nil
    else
      if item_code == item_name do
        nil
      else
        "<b>" <> item_name <> "</b>"
      end
    end
  end

  def end_date_count list do
    Enum.count(list, fn(x) -> (x.end_date |> String.length) == 0 end)
  end
end
