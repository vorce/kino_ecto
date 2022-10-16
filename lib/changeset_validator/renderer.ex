defmodule Lively.ChangesetValidator.Renderer do
  def call(changeset_result) do
    Kino.Markdown.new(changeset_result)
  end
end
