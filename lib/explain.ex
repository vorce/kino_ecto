defmodule Lively.Explain do
  @moduledoc """
  Parse and render query explain results
  """
  alias Lively.Explain.Node

  defstruct [:plan, :execution_time, :planning_time, :raw]

  @postgres_opts [
    analyze: true,
    verbose: true,
    costs: true,
    settings: true,
    buffers: true,
    timing: true,
    summary: true,
    format: :map
  ]

  @doc """
  Creates a `Lively.Explain` struct that can be rendered based on a queryable.
  """
  def call(repo, operation, queryable, opts \\ []) do
    opts = Keyword.merge(opts, @postgres_opts)

    repo
    |> Ecto.Adapters.SQL.explain(operation, queryable, opts)
    |> new()
  end

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
