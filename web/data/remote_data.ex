defmodule RemoteData do

  def clear_cache do
    for {key,_} <- ConCache.ets(:my_cache) |> :ets.tab2list do
      ConCache.delete(:my_cache, key)
    end
  end

  def data_list register, data_file do
    url = "https://raw.githubusercontent.com/openregister/#{data_file}"
    file_path = "../#{data_file}" |> String.replace("/master","")
    ConCache.get_or_store(:my_cache, register, get_list(url, file_path, register))
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

  defp maps_url_and_path file, maps_path do
    url = "https://raw.githubusercontent.com/openregister/#{maps_path}/#{file}"
    file_path = "../#{maps_path}/#{file}" |> String.replace("/master","")
    [url, file_path]
  end

  defp map_list file, maps_path do
    [url, file_path] = maps_url_and_path("#{file}.tsv", maps_path)
    ConCache.get_or_store(:my_cache, file, get_list(url, file_path, file))
  end

  defp get_maps_index maps_path do
    fn () ->
      [url, file_path] = maps_url_and_path("index.yml", maps_path)
      url
      |> retrieve_data(file_path)
      |> YamlElixir.read_from_string
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
