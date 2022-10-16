defmodule Lively do
  alias Lively.EntityRelationship

  defdelegate explain(repo, operation, queryable, opts \\ []), to: Lively.Explain, as: :call

  defimpl Kino.Render, for: EntityRelationship do
    def to_livebook(struct) do
      er = EntityRelationship.call(struct)

      tabs =
        Kino.Layout.tabs(
          Raw: Kino.Inspect.new(struct.schema),
          "Entity Relationship Diagram": er
        )

      Kino.Render.to_livebook(tabs)
    end
  end
end
