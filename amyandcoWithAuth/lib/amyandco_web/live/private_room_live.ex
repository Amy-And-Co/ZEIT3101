defmodule AmyandcoWeb.PrivateRoomLive do
  use AmyandcoWeb, :live_view
  require Logger
  import Ecto.Query, warn: false
  alias Amyandco.Chats.Message
  alias Amyandco.PrivMessages
  alias Amyandco.Account
  alias Amyandco.Account
  alias AmyandcoWeb.UserAuth
  alias AmyandcoWeb.Router.Helpers, as: Routes
  alias AmyandcoWeb.LiveAuth

  @impl true
  def mount(_params, session, socket) do
    topic = "Private Room"
    email = Account.get_user_by_session_token(session["user_token"]).email
    username = Enum.at(String.split(email, "@"),0)
    messages = PrivMessages.list_posts()
    changeset = Message.changeset(%Message{}, %{})
    if connected?(socket) do
      AmyandcoWeb.Endpoint.subscribe(topic)
      AmyandcoWeb.Presence.track(self(), topic, username, %{})
    end
    {:ok,
     assign(socket,
      changeset: changeset,
       topic: topic,
       username: username,
       message: "",
       messages: messages,
       user_list: [],
       temporary_assigns: [messages: []],
       chat_color: "background: rgb(238,174,202);background: linear-gradient(52deg, rgba(238,174,202,1) 0%, rgba(148,187,233,1) 100%);"
     )}
  end

  @impl true
  def handle_event("submit_message", %{"chat" => %{"message" => message}}, socket) do
    message = %{username: socket.assigns.username, body: message}
    if message.body != "" do
      AmyandcoWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", message)
      case PrivMessages.create_post(message) do
        {:ok, _post} ->
          {:noreply,
           socket
           |> put_flash(:info, "Post created successfully")}
        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, changeset: changeset)}
      end
    end
    {:noreply, assign(socket, message: "")}
  end

  @impl true
  def handle_info(%{event: "new-message", payload: message}, socket) do
    {:noreply, assign(socket, messages: [message])}
  end

  @impl true
  def handle_event("form_update", %{"chat" => %{"message" =>message}}, socket) do
    {:noreply, assign(socket, message: message)}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    join_messages =
      joins
      |> Map.keys()
      |> Enum.map(fn username -> %{type: :system, uuid: UUID.uuid4(), body: "#{username} joined"} end)


    leave_messages =
        leaves
        |> Map.keys()
        |> Enum.map(fn username -> %{type: :system, uuid: UUID.uuid4(), body: "#{username} left"} end)

    user_list = AmyandcoWeb.Presence.list(socket.assigns.topic)
    |> Map.keys()

    {:noreply, assign(socket, messages: join_messages ++ leave_messages, user_list: user_list)}
  end

  def display_message(%{type: :system, uuid: uuid, body: body}, yah: yah) do
    ~E"""
    <p id="<%= uuid %>" style="color:black;""><em><%= body %></em></p>
    """
  end

  def display_message(%{body: body, username: username}, yah: yah) do
    uuid = UUID.uuid4()
    if username == yah do
    ~E"""
    <div id="<%= uuid %><>4b"style="justify-content: right;display: flex;flex-direction:row-reverse;">
    <p id="<%= uuid %>" style="text-align:right;display: inline-block;padding:10px 15px;background:rgba(173,216,230,0.8);margin:3px;border-radius:20px;">
    <%= body %></p>
    </div>
    """
    else
    ~E"""
    <div id="<%= uuid %><>4b"style="justify-content: left;display: flex;flex-direction:row;">
    <p id="<%= uuid %>" style="text-align:left;display: inline-block;padding:10px 15px;background:rgba(238,174,202,0.8);margin:3px;border-radius:20px;"><strong><%= username %></strong>: <%= body %></p>
    </div>
    """
    end
  end

  def display_message(%{__meta__: meta, id: id, body: body, username: username}, yah: yah) do
    Logger.info(body)
    if username == yah do
    ~E"""
    <div id="<%= id %><>4b"style="justify-content: right;display: flex;flex-direction:row-reverse;">
    <p id="<%= id %>" style="text-align:right;display: inline-block;padding:10px 15px;background:rgba(173,216,230,0.8);margin:3px;border-radius:20px;">
    <%= body %></p>
    </div>
    """
    else
    ~E"""
    <div id="<%= id %><>4b"style="justify-content: left;display: flex;flex-direction:row;">
    <p id="<%= id %>" style="text-align:left;display: inline-block;padding:10px 15px;background:rgba(238,174,202,0.8);margin:3px;border-radius:20px;"><strong><%= username %></strong>: <%= body %></p>
    </div>
    """
    end
  end

  @impl true
  def handle_event("change_color", %{"value" =>color}, socket) do
    chosencolor = case color do
       "style1" -> "background: rgb(238,174,202); background: linear-gradient(52deg, rgba(238,174,202,1) 0%, rgba(148,187,233,1) 100%);"
       "style2" -> "background: rgb(34,193,195); background: linear-gradient(62deg, rgba(34,193,195,1) 0%, rgba(253,187,45,1) 100%); "
       "style3" -> "background: rgb(131,58,180); background: linear-gradient(31deg, rgba(131,58,180,1) 0%, rgba(253,29,29,1) 50%, rgba(252,176,69,1) 100%);"
       "style4" -> " background: rgb(2,145,0); background: linear-gradient(31deg, rgba(2,145,0,1) 0%, rgba(167,253,29,0.6180672952774859) 50%, rgba(228,252,69,0.8953782196472339) 100%);"
       "style5" -> " background: linear-gradient(to top, #cfd9df 0%, #e2ebf0 100%);"
       "style6" -> "background: linear-gradient(to bottom, rgba(255,255,255,0.15) 0%, rgba(0,0,0,0.15) 100%), radial-gradient(at top center, rgba(255,255,255,0.40) 0%, rgba(0,0,0,0.40) 120%) #989898;
       background-blend-mode: multiply,multiply;"
       _ -> "background: rgb(238,174,202); background: linear-gradient(52deg, rgba(238,174,202,1) 0%, rgba(148,187,233,1) 100%);"
    end
    {:noreply, assign(socket, chat_color: chosencolor)}
  end

  def display_chat_box(chat_color) do
    ~E"""
    <div id="chat-container" style="<%= chat_color %>">
    """
  end

end
