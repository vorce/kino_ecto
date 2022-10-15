defmodule Lively.ExplainTest do
  use ExUnit.Case

  alias Lively.Explain
  alias Lively.Test.Support.ExplainData

  test "render mermaid graph" do
    explain = Explain.new(ExplainData.big_plan())
    assert {:js, %{export: %{info_string: "mermaid"}}} = Kino.Render.to_livebook(explain)
  end
end
