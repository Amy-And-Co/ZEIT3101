defmodule AmyandcoWeb.LiveAuth do
  import Phoenix.LiveView

  alias Amyandco.Account
  alias Amyandco.Account.User
  alias AmyandcoWeb.Router.Helpers, as: Routes

  def on_mount(:require_authenticated_user, _, session, socket) do
    socket = assign_current_user(socket, session)
    case socket.assigns.current_user do
      nil ->
        {:halt,
          socket
          |> put_flash(:error, "You have to Sign in to continue")
          |> redirect(to: Routes.user_session_path(socket, :new))}

      %{} ->
        {:cont, socket}

    end
  end

  defp assign_current_user(socket, session) do
    case session do
      %{"user_token" => user_token} ->
        assign_new(socket, :current_user, fn ->
          Account.get_user_by_session_token(user_token)
        end)

      %{} ->
        assign_new(socket, :current_user, fn -> nil end)

    end
  end

end