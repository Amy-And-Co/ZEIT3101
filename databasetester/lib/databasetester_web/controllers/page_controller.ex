defmodule DatabasetesterWeb.PageController do
  use DatabasetesterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
