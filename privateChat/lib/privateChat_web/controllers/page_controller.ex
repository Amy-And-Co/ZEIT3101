defmodule PrivateChatWeb.PageController do
  use PrivateChatWeb, :controller

  alias Chat.Chats

  def index(conn, _params) do
    messages = Chats.list_messages
    render(conn, "index.html", messages: messages)
  end
end
