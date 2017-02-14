defmodule RemoteData do

  def clear_cache do
    for {key,_} <- ConCache.ets(:my_cache) |> :ets.tab2list do
      ConCache.delete(:my_cache, key)
    end
  end

  def data_url data_file do
    "https://raw.githubusercontent.com/openregister/#{data_file}"
  end

  def data_list register, data_file do
    url = data_url data_file
    file_path = "../#{data_file}" |> String.replace("/master","")
    ConCache.get_or_store(:my_cache, register, get_list(url, file_path, register))
  end

  def maps_list maps_path, register do
    maps_path
    |> maps_index()
    |> Enum.map(& &1 |> Tuple.to_list |> List.first)
    |> Enum.reject(& &1 == register )
    |> Enum.map(&( [&1, map_list(&1, maps_path)] ))
  end

  def maps_order yaml do
    :yamerl_constr.string(yaml)
    |> List.first
    |> Enum.map(& &1 |> Tuple.to_list |> List.first |> to_string)
  end

  def maps_index maps_path do
    index_yaml = ConCache.get_or_store(:my_cache, maps_path, get_maps_index(maps_path))
    index_data = index_yaml |> YamlElixir.read_from_string
    index_order = index_yaml |> maps_order
    for tuple <- index_data do
      {key, map} = tuple
      case map do
        %{"description" => _, "key" => _} -> ; # valid
        _ -> raise("Map file data must have description and key: #{inspect(map)}")
      end
    end
    index_order |> Enum.map(& {&1, Map.get(index_data, &1)})
  end

  defp maps_url_and_path file, maps_path do
    url = "https://raw.githubusercontent.com/openregister/#{maps_path}/#{file}"
    file_path = "../#{maps_path}/#{file}" |> String.replace("/master","")
    [url, file_path]
  end

  def map_list file, maps_path do
    [url, file_path] = maps_url_and_path("#{file}.tsv", maps_path)
    ConCache.get_or_store(:my_cache, file, get_list(url, file_path, file))
  end

  defp get_maps_index maps_path do
    fn () ->
      [url, file_path] = maps_url_and_path("index.yml", maps_path)
      url
      |> retrieve_data(file_path)
    end
  end

  defp retrieve_data url, file_path do
    try do
      IO.puts url
      HTTPoison.get!(url).body
    rescue
      HTTPoison.Error ->
        IO.puts file_path
        {:ok, body} = File.read(file_path)
        body
    end
  end

  defp get_list url, file_path, kind do
    fn () ->
      url
      |> retrieve_data(file_path)
      |> String.replace_trailing("\n", "")
      |> DataMorph.structs_from_tsv(OpenRegister, kind)
      |> Enum.to_list
    end
  end
end
