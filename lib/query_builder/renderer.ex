defmodule Lively.QueryBuilder.Renderer do
  @moduledoc """
  Kino renderer for `Lively.QueryBuilder` structs
  """

  def call(query_result) do
    content = """
      **Ecto Query:**

      `#{inspect(query_result)}`
    """

    Kino.Markdown.new(content)
  end
end
