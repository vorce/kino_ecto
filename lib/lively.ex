defmodule Lively do
  alias Lively.EntityRelationship

  defdelegate explain(repo, operation, queryable, opts \\ []), to: Lively.Explain, as: :call

  defimpl Kino.Render, for: EntityRelationship do
    def to_livebook(er) do
      raw = er.schema
      diagram = EntityRelationship.call(er)

      tabs = Kino.Layout.tabs(Raw: raw, "Entity Relationship Diagram": diagram)

      Kino.Render.to_livebook(tabs)
    rescue
      _ -> Kino.Render.to_livebook(er.schema)
    end
  end
end
