defmodule Stuck.V1.FragmentView do
  use Stuck.Web, :view

  def render("index.json", %{fragments: fragments}) do
    %{data: render_many(fragments, Stuck.V1.FragmentView, "fragment.json")}
  end

  def render("show.json", %{fragment: fragment}) do
    %{data: render_one(fragment, Stuck.V1.FragmentView, "fragment.json")}
  end

  def render("fragment.json", %{fragment: fragment}) do
    %{id: fragment.id,
      header: fragment.header,
      body: fragment.body,
      article_id: fragment.article_id}
  end
end
