defmodule KinoEcto.Explain.Postgres.Node do
  @moduledoc """
  Internal representation of a postgres query plan node
  """

  defstruct [
    # The type of node
    :type,

    # Extra details, to make it easier to understand what this node is for
    :details,

    # Child nodes
    children: [],

    # Metadata about the node's plan, like cost, timing etc.
    meta: [],

    # Heuristics that may be relevant when looking for issues
    warnings: []
  ]

  @doc """
  Build a tree of `KinoEcto.Explain.Postgres.Node` structs based on a postgres map format query plan
  from `Ecto.Adapters.SQL.explain/4`
  """
  def build_tree(nil), do: nil

  def build_tree(plan) do
    node = node_from_plan(plan)

    plan
    |> Map.get("Plans", [])
    |> Enum.reduce(node, fn child_plan, acc ->
      children = [build_tree(child_plan) | acc.children]
      new_meta = update_node_cost(node, children)
      %__MODULE__{acc | children: children, meta: new_meta}
    end)
  end

  defp node_from_plan(plan) do
    type = Map.get(plan, "Node Type", "Unknown")
    total_cost = Map.get(plan, "Total Cost")

    meta =
      Enum.reject(
        [
          timing: Map.get(plan, "Actual Total Time"),
          rows: Map.get(plan, "Actual Rows"),
          cost: %{total: total_cost, node: total_cost}
        ],
        fn {_, v} -> is_nil(v) end
      )

    %__MODULE__{
      type: type,
      details: node_details(type, plan),
      meta: meta,
      warnings: warnings(plan)
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

  defp warnings(plan) do
    [:bad_row_estimation]
    |> Enum.map(fn type -> check_warning(type, plan) end)
    |> Enum.reject(&is_nil/1)
  end

  defp check_warning(:bad_row_estimation, %{"Plan Rows" => plan_rows, "Actual Rows" => actual_rows}) do
    diff = actual_rows / plan_rows

    cond do
      actual_rows < 2 -> nil
      (diff > 1.0 and diff <= 1.1) or (diff < 1.0 and diff >= 0.9) -> nil
      diff > 1.0 -> {:row_estimation, "underestimated", round(diff)}
      diff < 1.0 -> {:row_estimation, "overestimated", round(plan_rows / actual_rows)}
      true -> nil
    end
  end

  defp check_warning(_, _), do: nil

  # Calculate the sub cost of a node, by summing the cost of its children.
  def sub_cost([]), do: 0

  def sub_cost([node | rest]) do
    Enum.reduce(node.children, 0, fn elem, acc -> acc + elem.meta[:cost].total end) + sub_cost(rest)
  end

  defp update_node_cost(node, children) do
    sub_cost = sub_cost(children)
    node_cost = Float.round(node.meta[:cost].total - sub_cost, 2)
    cost_map = %{node.meta[:cost] | node: node_cost}
    Keyword.update(node.meta, :cost, cost_map, fn existing_cost -> Map.put(existing_cost, :node, node_cost) end)
  end
end
