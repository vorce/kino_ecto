defmodule Lively.ExplainTest do
  use ExUnit.Case

  alias Lively.Explain
  alias Lively.Test.Support.ExplainData

  test "render two tabs" do
    explain = Explain.new(ExplainData.big_plan())

    assert {:tabs, [{:js, %{export: %{info_string: "mermaid"}}}, {:text, _}], %{labels: ["Plan", "Raw"]}} =
             Kino.Render.to_livebook(explain)
  end

  test "contains original plan" do
    plan = ExplainData.big_plan()

    explain = Explain.new(plan)

    assert explain.raw == plan
  end
end
