defmodule Databasetester.PrivMessagesTest do
  use Databasetester.DataCase

  alias Databasetester.PrivMessages

  describe "posts" do
    alias Databasetester.PrivMessages.Post

    import Databasetester.PrivMessagesFixtures

    @invalid_attrs %{body: nil, username: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert PrivMessages.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert PrivMessages.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{body: "some body", username: "some username"}

      assert {:ok, %Post{} = post} = PrivMessages.create_post(valid_attrs)
      assert post.body == "some body"
      assert post.username == "some username"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PrivMessages.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{body: "some updated body", username: "some updated username"}

      assert {:ok, %Post{} = post} = PrivMessages.update_post(post, update_attrs)
      assert post.body == "some updated body"
      assert post.username == "some updated username"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = PrivMessages.update_post(post, @invalid_attrs)
      assert post == PrivMessages.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = PrivMessages.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> PrivMessages.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = PrivMessages.change_post(post)
    end
  end
end
