defmodule KinoEcto.Explain do
  @moduledoc """
  Parse and render query explain results
  """
  defstruct [:plan, :execution_time, :planning_time, :raw]

  @adapter_explain %{
    Ecto.Adapters.Postgres => KinoEcto.Explain.Postgres
  }

  @doc """
  Creates a struct that can be rendered based on a queryable.
  """
  def call(repo, operation, queryable, opts \\ []) do
    adapter = repo.__adapter__()

    with {:ok, explain_module} <- explain_module(adapter) do
      opts = Keyword.merge(opts, explain_module.options())

      repo
      |> Ecto.Adapters.SQL.explain(operation, queryable, opts)
      |> explain_module.new()
    end
  end

  defp explain_module(adapter) do
    case Map.fetch(@adapter_explain, adapter) do
      {:ok, module} -> {:ok, module}
      :error -> {:error, {:unsupported_adapter, adapter}}
    end
  end
end
