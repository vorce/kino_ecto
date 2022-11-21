defmodule KinoEcto.EntityRelationshipTest do
  use ExUnit.Case
  doctest KinoEcto.EntityRelationship

  alias KinoEcto.EntityRelationship

  defmodule Organization do
    use Ecto.Schema
    alias KinoEcto.EntityRelationshipTest.Team

    schema "organizations" do
      field(:name, :string)
      has_one(:team, Team)
    end
  end

  defmodule Team do
    use Ecto.Schema
    alias KinoEcto.EntityRelationshipTest.Person

    schema "teams" do
      field(:name, :string)
      has_many(:persons, Person)
    end
  end

  defmodule Person do
    use Ecto.Schema
    alias KinoEcto.EntityRelationshipTest.{Organization, Team}

    schema "persons" do
      field(:name, :string)
      field(:age, :integer)

      has_one(:team, Team)
      belongs_to(:organization, Organization)
    end
  end

  test "render schema" do
    alias KinoEcto.EntityRelationshipTest.Person
    assert {:markdown, md} = Kino.Render.to_livebook(%EntityRelationship{schema: Person})

    assert md =~ "mermaid"
    assert md =~ "class `KinoEcto.EntityRelationshipTest.Team`"
    assert md =~ "`KinoEcto.EntityRelationshipTest.Team` : string name"
    assert md =~ "`KinoEcto.EntityRelationshipTest.Person` : integer age"

    assert md =~
             "`KinoEcto.EntityRelationshipTest.Organization` \"0\" --|> \"1\" `KinoEcto.EntityRelationshipTest.Team`"
  end
end
