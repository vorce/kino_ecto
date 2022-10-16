defmodule Lively.QueryBuilder.Renderer do
  @moduledoc """
  Kino renderer for `Lively.QueryBuilder` structs
  """

  alias Lively.QueryBuilder

  defimpl Kino.Render, for: QueryBuilder do
    def to_livebook(query) do
      query_result = QueryBuilder.call(query)

      tabs = Kino.Layout.tabs(Raw: inspect(query.sql_query), "Ecto Query": query_result)

      Kino.Render.to_livebook(tabs)
    end
  end

  def call(query_result) do
    content = """
      Ecto Query: #{query_result}.
    """

    Kino.Markdown.new(content)
  end
end
