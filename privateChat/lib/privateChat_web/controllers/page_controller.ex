defmodule PrivateChatWeb.PageController do
  use PrivateChatWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
