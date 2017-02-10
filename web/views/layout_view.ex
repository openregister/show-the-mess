defmodule ShowTheMess.LayoutView do
  use ShowTheMess.Web, :view

  def content_id(nil), do: "content"
  def content_id(register), do: "register-content"

end
