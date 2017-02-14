defmodule ShowTheMess.PageController do
  use ShowTheMess.Web, :controller

  def index(conn, params) do
    register = params |> Map.get("register")

    if is_nil(register) do
      render conn, "index.html", register: nil
    else
      data_file = params |> Map.get("data")
      maps_path = params |> Map.get("maps")

      data_list = RemoteData.data_list(register, data_file)
      maps_list = RemoteData.maps_list(maps_path, register)
      maps_index = RemoteData.maps_index(maps_path)
      data_url = RemoteData.data_url(data_file)

      render conn, "index.html",
        data_list: data_list,
        data_list_by_id: data_list |> Enum.group_by(& &1 |> Map.get(String.to_atom(register))),
        data_url: data_url,
        maps_list: maps_list,
        maps_index: maps_index,
        maps_path: maps_path,
        register: register
    end
  end

  def clear_cache(conn, _params) do
    RemoteData.clear_cache()
    text conn, "Cache cleared"
  end
end
