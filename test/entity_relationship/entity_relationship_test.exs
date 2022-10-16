defmodule Lively.EntityRelationshipTest do
  use ExUnit.Case
  doctest Lively.EntityRelationship

  alias Lively.EntityRelationship

  defmodule TestTeam do
    use Ecto.Schema

    schema "teams" do
      field(:name, :string)
    end
  end

  test "render schema" do
    assert {
             :tabs,
             [
               text: _,
               markdown: md
             ],
             %{labels: ["Raw", "Entity Relationship Diagram"]}
           } = Kino.Render.to_livebook(%EntityRelationship{schema: TestTeam})

    assert md =~ "mermaid"
    assert md =~ "string name"
  end
end
