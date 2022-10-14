defmodule AmyandcoWeb.PageLive do
  use AmyandcoWeb, :live_view
# Homepage event handler
  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{})}
  end
# Creates a public chatroom
  @impl true
  def handle_event("random-room", _params, socket) do
    random_slug = "/" <> MnemonicSlugs.generate_slug(4)
    {:noreply, push_redirect(socket, to: random_slug)}
  end
# Navigates to the public chatroom
  @impl true
  def handle_event("private-chat", _params, socket) do
    {:noreply, push_redirect(socket,to: "/private")}
  end
end
