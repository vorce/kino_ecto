defmodule Lively.Explain do
  @moduledoc """
  Parse and render query explain results
  """
  alias Lively.Explain.Node

  defstruct [:plan, :execution_time, :planning_time, :raw]

  @adapter_opts %{
    Ecto.Adapters.Postgres => [
      analyze: true,
      verbose: true,
      costs: true,
      settings: true,
      buffers: true,
      timing: true,
      summary: true,
      format: :map
    ]
  }

  @doc """
  Creates a `Lively.Explain` struct that can be rendered based on a queryable.
  """
  def call(repo, operation, queryable, opts \\ []) do
    adapter = repo.__adapter__()

    with {:ok, adapter_opts} <- adapter_opts(adapter) do
      opts = Keyword.merge(opts, adapter_opts)

      repo
      |> Ecto.Adapters.SQL.explain(operation, queryable, opts)
      |> new()
    end
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

  defp adapter_opts(adapter) do
    case Map.fetch(@adapter_opts, adapter) do
      {:ok, _} = opts -> opts
      :error -> {:error, {:unsupported_adapter, adapter}}
    end
  end
end
