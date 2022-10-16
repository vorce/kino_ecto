defmodule Lively do
  alias Lively.ChangesetValidator
  alias Lively.EntityRelationship
  alias Lively.Explain
  alias Lively.QueryBuilder

  defdelegate explain(repo, operation, queryable, opts \\ []), to: Explain, as: :call

  defimpl Kino.Render, for: EntityRelationship do
    def to_livebook(entity_relationship) do
      entity_relationship |> EntityRelationship.call() |> Kino.Render.to_livebook()
    end
  end

  defimpl Kino.Render, for: ChangesetValidator do
    def to_livebook(changeset_validator) do
      changeset_validator |> ChangesetValidator.call() |> Kino.Render.to_livebook()
    end
  end

  defimpl Kino.Render, for: QueryBuilder do
    def to_livebook(query) do
      query |> QueryBuilder.call() |> Kino.Render.to_livebook()
    end
  end
end
