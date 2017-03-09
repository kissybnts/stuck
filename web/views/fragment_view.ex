defmodule Stuck.FragmentView do
  use Stuck.Web, :view

  def render("index.json", %{fragments: fragments}) do
    %{data: render_many(fragments, Stuck.FragmentView, "fragment.json")}
  end

  def render("show.json", %{fragment: fragment}) do
    %{data: render_one(fragment, Stuck.FragmentView, "fragment.json")}
  end

  def render("fragment.json", %{fragment: fragment}) do
    %{id: fragment.id,
      header: fragment.header,
      body: fragment.body,
      article_id: fragment.article_id}
  end
end
