defmodule ShowTheMess.PageController do
  use ShowTheMess.Web, :controller

  def index(conn, params) do
    register = params |> Map.get("register", "prison")
    data_file = params |> Map.get("data", "prison-data/master/data/discovery/prison/prisons.tsv")
    maps_path = params |> Map.get("maps", "prison-data/master/maps")

    data_list = RemoteData.data_list(register, data_file)
    maps_list = RemoteData.maps_list(maps_path, register)
    maps_index = RemoteData.maps_index(maps_path)
    render conn, "index.html",
      data_list: data_list,
      data_list_by_id: data_list |> Enum.group_by(& &1 |> Map.get(String.to_atom(register))),
      maps_list: maps_list,
      maps_index: maps_index,
      register: register
  end
end
