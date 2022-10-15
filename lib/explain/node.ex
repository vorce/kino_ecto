defmodule Lively.Explain.Node do
  @moduledoc """
  Internal representation of a query plan node
  """

  defstruct [
    :type,
    :details,
    children: [],
    meta: []
  ]

  @doc """
  Build a tree of `Lively.Explain.Node` structs based on a (postgres map format) query plan
  from `Ecto.Adapters.SQL.explain/4`
  """
  def build_tree(nil), do: nil

  def build_tree(plan) do
    node = node_from_plan(plan)

    plan
    |> Map.get("Plans", [])
    |> Enum.reduce(node, fn child_plan, acc ->
      %__MODULE__{acc | children: [build_tree(child_plan) | acc.children]}
    end)
  end

  defp node_from_plan(plan) do
    type = Map.get(plan, "Node Type", "Unknown")

    meta =
      Enum.reject(
        [
          timing: Map.get(plan, "Actual Total Time"),
          rows: Map.get(plan, "Actual Rows"),
          cost: Map.get(plan, "Total Cost")
        ],
        fn {_, v} -> is_nil(v) end
      )

    %__MODULE__{
      type: type,
      details: node_details(type, plan),
      meta: meta
    }
  end

  defp node_details("Hash Join", plan) do
    Map.get(plan, "Join Type") <> " on " <> Map.get(plan, "Hash Cond")
  end

  defp node_details("Index Scan", plan) do
    index_name = Map.get(plan, "Index Name")
    "on #{table_name(plan)} using #{index_name}"
  end

  defp node_details("Index Only Scan", plan) do
    node_details("Index Scan", plan)
  end

  defp node_details("Nested Loop", plan), do: Map.get(plan, "Join Type")

  defp node_details("Seq Scan", plan) do
    "on #{table_name(plan)}"
  end

  defp node_details("Sort", plan), do: Map.get(plan, "Sort Key", []) |> Enum.join(", ")
  defp node_details(_, _plan), do: nil

  defp table_name(plan) do
    schema = Map.get(plan, "Schema")
    relation = Map.get(plan, "Relation Name")

    cond do
      is_binary(schema) and is_binary(relation) -> "#{schema}.#{relation}#{table_alias(plan)}"
      is_binary(relation) -> "#{relation}#{table_alias(plan)}"
    end
  end

  defp table_alias(%{"Alias" => the_alias}) do
    " as #{the_alias}"
  end

  defp table_alias(_), do: nil
end
