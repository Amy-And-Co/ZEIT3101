defmodule AmyandcoWeb.PrivateRoomLive do
  use AmyandcoWeb, :live_view
  require Logger
  import Ecto.Query, warn: false
  alias Amyandco.Chats.Message


  @impl true
  def mount(_params, _session, socket) do
    topic = "Private Room"
    username = MnemonicSlugs.generate_slug(2)
    messages = Message.list_messages() |> Enum.reverse()
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
    message = %{uuid: UUID.uuid4(), content: message, username: socket.assigns.username}
    if message.content != "" do
      AmyandcoWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", message)
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
      |> Enum.map(fn username -> %{type: :system, uuid: UUID.uuid4(), content: "#{username} joined"} end)

    leave_messages =
        leaves
        |> Map.keys()
        |> Enum.map(fn username -> %{type: :system, uuid: UUID.uuid4(), content: "#{username} left"} end)

    user_list = AmyandcoWeb.Presence.list(socket.assigns.topic)
    |> Map.keys()

    {:noreply, assign(socket, messages: join_messages ++ leave_messages, user_list: user_list)}
  end

  def display_message(%{type: :system, uuid: uuid, content: content}, yah: yah) do
    ~E"""
    <p id="<%= uuid %>" style="color:black;""><em><%= content %></em></p>
    """
  end

  def display_message(%{uuid: uuid, content: content, username: username}, yah: yah) do
    if username == yah do
    ~E"""
    <div id="<%= uuid %><>4b"style="justify-content: right;display: flex;flex-direction:row-reverse;">
    <p id="<%= uuid %>" style="text-align:right;display: inline-block;padding:10px 15px;background:rgba(173,216,230,0.8);margin:3px;border-radius:20px;">
    <%= content %></p>
    </div>
    """
    else
    ~E"""
    <div id="<%= uuid %><>4b"style="justify-content: left;display: flex;flex-direction:row;">
    <p id="<%= uuid %>" style="text-align:left;display: inline-block;padding:10px 15px;background:rgba(238,174,202,0.8);margin:3px;border-radius:20px;"><strong><%= username %></strong>: <%= content %></p>
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
