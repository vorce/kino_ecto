defmodule KinoEcto.Explain.Postgres.RendererTest do
  use ExUnit.Case, async: true

  alias KinoEcto.Explain.Postgres
  alias KinoEcto.Explain.Postgres.Renderer
  alias KinoEcto.Test.Support.ExplainData

  test "build_mermaid_graph/1" do
    explain = Postgres.new(ExplainData.single_node_plan())

    result = Renderer.build_mermaid_graph(explain)

    assert result =~ "Seq Scan"
  end
end
