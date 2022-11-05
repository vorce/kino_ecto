defmodule KinoEcto.Explain.PostgresTest do
  use ExUnit.Case, async: true

  alias KinoEcto.Explain.Postgres
  alias KinoEcto.Test.Support.ExplainData

  test "render two tabs" do
    explain = Postgres.new(ExplainData.big_plan())

    assert {:tabs, [{:js, %{export: %{info_string: "mermaid"}}}, {:text, _}], %{labels: ["Plan", "Raw"]}} =
             Kino.Render.to_livebook(explain)
  end

  test "contains original plan" do
    plan = ExplainData.big_plan()

    explain = Postgres.new(plan)

    assert explain.raw == plan
  end
end
