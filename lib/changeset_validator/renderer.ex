defmodule Lively.ChangesetValidator.Renderer do
  @moduledoc """
  Kino renderer for `Lively.ChangesetValidator` structs
  """

  alias Lively.ChangesetValidator

  defimpl Kino.Render, for: ChangesetValidator do
    def to_livebook(changeset_validator) do
      changeset_result = ChangesetValidator.call(changeset_validator)

      tabs = Kino.Layout.tabs(Raw: inspect(changeset_validator), "Changeset Validator Result": changeset_result)

      Kino.Render.to_livebook(tabs)
    end
  end

  def call(changeset_result) do
    content = """
      Changeset valid? #{changeset_result.valid?}.

      Errors: #{inspect(changeset_result.errors)}.
    """
    Kino.Markdown.new(content)
  end
end
