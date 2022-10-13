defmodule Amyandco.PrivMessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Amyandco.PrivMessages` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body",
        username: "some username"
      })
      |> Amyandco.PrivMessages.create_post()

    post
  end
end
