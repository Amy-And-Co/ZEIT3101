defmodule PrivateChatWeb.ChatChannel do
  use PrivateChatWeb, :channel

  #auth logic goes here
  @impl true
  def join("chat:lobby", _payload, socket) do
    {:ok, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  #defp authorized?(_payload) do
  #  true
  #end
end
