defmodule KinoEcto.ChangesetValidator.Renderer do
  @moduledoc """
  Kino renderer for `KinoEcto.ChangesetValidator` structs
  """

  def call(changeset_result) do
    errors =
      changeset_result.errors
      |> Enum.map(&build_error/1)
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

    Kino.Markdown.new(content)
  end

  defp build_error({field, {message, error_data}}) do
    "`#{field}`: #{message} due to `#{Keyword.get(error_data, :validation)}` validation"
  end
end
