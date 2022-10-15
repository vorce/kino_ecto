defmodule LivelyTest do
  use ExUnit.Case
  doctest Lively

  defmodule TestTeam do
    use Ecto.Schema

    schema "teams" do
      field(:name, :string)
    end
  end

  test "render schema" do
    assert Kino.Render.to_livebook(%Lively{schema: %TestTeam{}}) ==
             {:tabs,
              [
                text:
                  "%LivelyTest.TestTeam{\e[34m__meta__:\e[0m #Ecto.Schema.Metadata<\e[34m:built\e[0m, \e[32m\"teams\"\e[0m>, \e[34mid:\e[0m \e[35mnil\e[0m, \e[34mname:\e[0m \e[35mnil\e[0m}",
                markdown:
                  "```mermaid\nclassDiagram\nclass LivelyTest.TestTeam\nLivelyTest.TestTeam : id id\nLivelyTest.TestTeam : string name\n```\n"
              ], %{labels: ["Raw", "Entity Relationship Diagram"]}}
  end
end
