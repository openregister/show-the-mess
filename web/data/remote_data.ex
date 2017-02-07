defmodule RemoteData do

  def clear_cache do
    for {key,_} <- ConCache.ets(:my_cache) |> :ets.tab2list do
      ConCache.delete(:my_cache, key)
    end
  end

  def data_list register, data_file do
    url = "https://raw.githubusercontent.com/openregister/#{data_file}"
    ConCache.get_or_store(:my_cache, register, get_list(url, register))
  end

  def maps_list maps_path do
    maps_path
    |> maps_index()
    |> Map.keys
    |> Enum.map(&( [&1, map_list(&1, maps_path)] ))
  end

  def maps_index maps_path do
    ConCache.get_or_store(:my_cache, "index", get_maps_index(maps_path))
  end

  defp maps_url file, maps_path do
    "https://raw.githubusercontent.com/openregister/#{maps_path}/#{file}"
  end

  defp map_list file, maps_path do
    url = maps_url "#{file}.tsv", maps_path
    ConCache.get_or_store(:my_cache, file, get_list(url, file))
  end

  defp get_maps_index maps_path do
    fn () ->
      url = maps_url "index.yml", maps_path
      HTTPoison.get!(url).body
      |> YamlElixir.read_from_string
    end
  end

  defp get_list url, kind do
    fn () ->
      HTTPoison.get!(url).body
      |> String.replace_trailing("\n", "")
      |> DataMorph.structs_from_tsv(OpenRegister, kind)
      |> Enum.to_list
    end
  end
end
