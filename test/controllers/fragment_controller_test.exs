defmodule Stuck.FragmentControllerTest do
  use Stuck.ConnCase

  alias Stuck.Fragment
  @valid_attrs %{body: "some content", header: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, fragment_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    fragment = Repo.insert! %Fragment{}
    conn = get conn, fragment_path(conn, :show, fragment)
    assert json_response(conn, 200)["data"] == %{"id" => fragment.id,
      "header" => fragment.header,
      "body" => fragment.body,
      "article_id" => fragment.article_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, fragment_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, fragment_path(conn, :create), fragment: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Fragment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, fragment_path(conn, :create), fragment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    fragment = Repo.insert! %Fragment{}
    conn = put conn, fragment_path(conn, :update, fragment), fragment: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Fragment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    fragment = Repo.insert! %Fragment{}
    conn = put conn, fragment_path(conn, :update, fragment), fragment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    fragment = Repo.insert! %Fragment{}
    conn = delete conn, fragment_path(conn, :delete, fragment)
    assert response(conn, 204)
    refute Repo.get(Fragment, fragment.id)
  end
end
