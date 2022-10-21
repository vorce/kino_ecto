defmodule KinoEcto.QueryBuilder.Renderer do
  @moduledoc """
  Kino renderer for `KinoEcto.QueryBuilder` structs
  """

  def call(query_result) do
    content = """
      **Ecto Query:**

      `#{inspect(query_result)}`
    """

    Kino.Markdown.new(content)
  end
end
