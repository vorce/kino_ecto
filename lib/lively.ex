defmodule Lively do
  alias Lively.ChangesetValidator
  alias Lively.EntityRelationship
  alias Lively.Explain

  defdelegate explain(repo, operation, queryable, opts \\ []), to: Explain, as: :call

  defimpl Kino.Render, for: EntityRelationship do
    def to_livebook(er) do
      er |> EntityRelationship.call() |> Kino.Render.to_livebook()
    end
  end

  defimpl Kino.Render, for: ChangesetValidator do
    def to_livebook(changeset_validator) do
      changeset_result = ChangesetValidator.call(changeset_validator)
      tabs = Kino.Layout.tabs(Raw: inspect(changeset_validator), "Changeset Validator Result": changeset_result)

      Kino.Render.to_livebook(tabs)
    end
  end
end
