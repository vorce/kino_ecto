defmodule Lively.ChangesetValidator.Renderer do
  @moduledoc """
  Kino renderer for `Lively.ChangesetValidator` structs
  """

  def call(changeset_result) do
    content = """
      Changeset valid? #{changeset_result.valid?}.

      Errors: #{inspect(changeset_result.errors)}.
    """

    Kino.Markdown.new(content)
  end
end
