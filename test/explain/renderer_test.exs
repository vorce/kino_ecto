defmodule KinoEcto.Explain.RendererTest do
  use ExUnit.Case

  alias KinoEcto.Explain
  alias KinoEcto.Explain.Renderer
  alias KinoEcto.Test.Support.ExplainData

  test "build_mermaid_graph/1" do
    explain = Explain.new(ExplainData.single_node_plan())

    result = Renderer.build_mermaid_graph(explain)

    assert result =~ "Seq Scan"
  end
end
