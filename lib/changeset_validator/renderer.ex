defmodule Lively.ChangesetValidator.Renderer do
  @moduledoc """
  Kino renderer for `Lively.ChangesetValidator` structs
  """

  def call(changeset_result) do
    errors =
      changeset_result.errors
      |> Enum.map(fn {field, {message, stuff}} ->
        "`#{field}`: #{message} due to #{Keyword.get(stuff, :validation)} validation"
      end)
      |> Enum.map(&"* #{&1}")
      |> Enum.join("\n")

    content = """
      **Changeset valid?** #{if changeset_result.valid?, do: "🟢", else: "🔴"}
      #{unless changeset_result.valid? do
      """
      **Errors:**
      #{errors}
      """
    end}
    """

    IO.inspect(content)
    Kino.Markdown.new(content)
  end
end
