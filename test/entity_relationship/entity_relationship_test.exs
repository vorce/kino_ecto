defmodule KinoEcto.EntityRelationshipTest do
  use ExUnit.Case
  doctest KinoEcto.EntityRelationship

  alias KinoEcto.EntityRelationship

  defmodule TestTeam do
    use Ecto.Schema

    schema "teams" do
      field(:name, :string)
    end
  end

  test "render schema" do
    assert {:markdown, md} = Kino.Render.to_livebook(%EntityRelationship{schema: TestTeam})

    assert md =~ "mermaid"
    assert md =~ "string name"
  end
end
