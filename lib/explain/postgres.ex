defmodule KinoEcto.Explain.Postgres do
  @moduledoc """
  Parse and render postgres query explain results
  """
  @behaviour KinoEcto.Explain.Visualizer

  alias KinoEcto.Explain.Postgres.Node

  defstruct [:plan, :execution_time, :planning_time, :raw]

  @options [
    analyze: true,
    verbose: true,
    costs: true,
    settings: true,
    buffers: true,
    timing: true,
    summary: true,
    format: :map
  ]

  @impl true
  defp options(), do: options

  @impl true
  def new(explain_result) when is_list(explain_result) do
    top_plan = List.first(explain_result)

    %__MODULE__{
      execution_time: top_plan["Execution Time"],
      planning_time: top_plan["Planning Time"],
      plan: Node.build_tree(top_plan["Plan"]),
      raw: explain_result
    }
  end
end
