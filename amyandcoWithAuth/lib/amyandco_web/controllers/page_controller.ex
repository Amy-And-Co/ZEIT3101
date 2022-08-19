defmodule AmyandcoWeb.PageController do
  use AmyandcoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
