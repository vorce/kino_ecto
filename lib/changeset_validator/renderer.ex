defmodule Lively.ChangesetValidator.Renderer do
  @moduledoc """
  Kino renderer for `Lively.ChangesetValidator` structs
  """

  alias Lively.ChangesetValidator

  defimpl Kino.Render, for: Lively.ChangesetValidator do
    def to_livebook(changeset_validator) do
      changeset_result = ChangesetValidator.call(changeset_validator)
      Kino.Markdown.new(changeset_result)
    end
  end

  def call(changeset_result) do
    Kino.Markdown.new(changeset_result)
  end
end
