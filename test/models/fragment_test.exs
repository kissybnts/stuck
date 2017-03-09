defmodule Stuck.FragmentTest do
  use Stuck.ModelCase

  alias Stuck.Fragment

  @valid_attrs %{body: "some content", header: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Fragment.changeset(%Fragment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Fragment.changeset(%Fragment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
