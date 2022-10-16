defmodule Lively do
  alias Lively.EntityRelationship

  defdelegate explain(repo, operation, queryable, opts \\ []), to: Lively.Explain, as: :call

  defimpl Kino.Render, for: EntityRelationship do
    def to_livebook(%{schema: %{__meta__: %Ecto.Schema.Metadata{}} = module}) do
      tabs =
        Kino.Layout.tabs(
          Raw: Kino.Inspect.new(module),
          "Entity Relationship Diagram": EntityRelationship.call(module)
        )

      Kino.Render.to_livebook(tabs)
    end

    def to_livebook(module), do: Kino.Render.to_livebook(module)
  end
end
