defmodule Lively.Explain do
  @moduledoc """
  Parse and render query explain results
  """
  defstruct [:plan, :execution_time, :planning_time]

  defmodule Node do
    defstruct [
      :type,
      children: [],
      meta: []
    ]
  end

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
      plan: build_tree(top_plan["Plan"])
    }
  end

  def build_tree(nil), do: nil

  def build_tree(plan) do
    node = node_from_plan(plan)

    plan
    |> Map.get("Plans", [])
    |> Enum.reduce(node, fn child_plan, acc ->
      %Node{acc | children: [build_tree(child_plan) | acc.children]}
    end)
  end

  defp node_from_plan(plan) do
    meta = Enum.reject([
      timing: Map.get(plan, "Actual Total Time"),
      rows: Map.get(plan, "Actual Rows"),
      cost: Map.get(plan, "Total Cost")
    ], fn {_, v} -> is_nil(v) end)

    %Node{
      type: Map.get(plan, "Node Type", "Unknown"),
      meta: meta
    }
  end

  defimpl Kino.Render, for: Lively.Explain do
    def to_livebook(explain) do
      lines = node_mermaid_lines(explain.plan, "T", "")

      graph = """
      graph TB
      subgraph Total
      TimeE[Execution time: #{explain.execution_time}ms]
      TimeP[Planning time: #{explain.planning_time}ms]
      end

      #{lines}
      """

      graph
      |> Kino.Mermaid.new()
      |> Kino.Render.to_livebook()
    end

    defp node_mermaid_lines(%Node{children: []}, _, acc), do: acc

    defp node_mermaid_lines(
           %Node{children: children} = node,
           label,
           acc
         ) do
      node_value = node_value(node)
      lines =
        children
        |> Enum.with_index()
        |> Enum.reduce("", fn {child, index}, node_lines ->
          child_label = "#{label}#{index}"
          child_value = node_value(child)
          node_lines <> "\t#{label}(#{node_value})-->#{child_label}(#{child_value})\n"
        end)

      lines <>
        (children
         |> Enum.with_index()
         |> Enum.reduce("", fn {child, index}, child_lines ->
           child_label = "#{label}#{index}"
           child_lines <> node_mermaid_lines(child, child_label, acc)
         end))
    end

    defp node_value(%Node{meta: []} = node) do
      "#{node.type}"
    end

    defp node_value(%Node{meta: meta} = node) do
      meta_items = Enum.map(meta, fn kv -> "<li>#{meta_value(kv)}</li>" end)
      "#{node.type}<br /><small><ul>#{meta_items}</ul></small>"
    end

    defp meta_value({:timing, timing_ms}), do: "timing: #{timing_ms}ms"
    defp meta_value({key, val}), do: "#{key}: #{val}"
  end
end
