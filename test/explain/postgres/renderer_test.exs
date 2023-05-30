defmodule KinoEcto.Explain.Postgres.RendererTest do
  use ExUnit.Case, async: true

  alias KinoEcto.Explain.Postgres
  alias KinoEcto.Explain.Postgres.Renderer
  alias KinoEcto.Test.Support.ExplainData

  describe "build_graph/1" do
    test "big_plan" do
      explain = Postgres.new(ExplainData.big_plan())

      result = Renderer.build_graph(explain)

      assert result =~ "Seq Scan"
    end
  end
end
