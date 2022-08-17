defmodule Amyandco.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Amyandco.Repo
  alias __MODULE__

  schema "messages" do
    field :body, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :body])
    |> validate_required([:name, :body])
  end

  def create_message(attrs) do
    %Message{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def list_messages do
    Message
    |> limit(20)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end
end
