defmodule KinoEcto.Explain.Postgres.Renderer do
  require EEx

  @moduledoc """
  Kino renderer for `KinoEcto.Explain.Postgres` structs

  Draws a graph of the query plan, inspired by: https://explain.dalibo.com/
  """

  EEx.function_from_file(:def, :graph, "lib/explain/postgres/graph.eex", [:assigns], trim: true)

  alias KinoEcto.Explain.Postgres.Node

  def build_graph(explain) do
    {nodes, lines} = build_mermaid_graph(explain.plan, "T", {[], []})

    graph(
      nodes: nodes,
      lines: lines,
      execution_time: explain.execution_time,
      planning_time: explain.planning_time
    )
  end

  defp build_mermaid_graph(%Node{children: []}, _id, {nodes, lines}), do: {nodes, lines}

  defp build_mermaid_graph(%Node{children: children} = node, id, {all_nodes, all_lines}) do
    reduce =
      if id == "T" do
        {[node_entry(node, id), node_style(node, id)], []}
      else
        {[], []}
      end

    {nodes, lines} =
      children
      |> Enum.with_index()
      |> Enum.reverse()
      |> Enum.reduce(reduce, fn {child, index}, {nodes, lines} ->
        child_id = "#{id}-#{index}"

        build_mermaid_graph(
          child,
          child_id,
          {[node_entry(child, child_id), node_style(child, child_id) | nodes], [line(id, child_id) | lines]}
        )
      end)

    {[nodes | all_nodes], [lines | all_lines]}
  end

  defp line(id, child_id) do
    [id, " --> ", child_id, "\n"]
  end

  defp node_entry(node, id) do
    [id, "(", node_value(node), ")\n"]
  end

  defp node_value(%Node{} = node) do
    [
      node.type,
      node_details(node),
      node_meta(node),
      node_warnings(node)
    ]
  end

  defp node_details(%{details: nil}), do: []
  defp node_details(%{details: details}), do: ["<br><span>", sanitize(details), "</span>"]
  defp node_meta(%{meta: []}), do: []

  defp node_meta(%{meta: meta}) do
    meta = for meta_item <- meta, do: ["<li>", meta_value(meta_item), "</li>"]
    ["<small><ul>", meta, "</ul></small>"]
  end

  defp node_warnings(%{warnings: []}), do: []

  defp node_warnings(%{warnings: warnings}) do
    warnings |> Enum.map(&warning_value/1) |> Enum.intersperse(" ")
  end

  @warning_background_color "#f9d6a7"
  defp node_style(%{warnings: []}, _node_id), do: []

  defp node_style(%{warnings: _warnings}, node_id) do
    ["style ", to_string(node_id), " fill:", @warning_background_color, ";\n"]
  end

  defp sanitize(string) do
    String.replace(string, ["(", ")", "\"", "[", "]"], "")
  end

  defp meta_value({:timing, timing_ms}), do: ["timing: ", to_string(timing_ms), "ms"]
  defp meta_value({:cost, %{total: total, node: node}}), do: ["cost: ", to_string(node), ", total: ", to_string(total)]
  defp meta_value({key, val}), do: [to_string(key), ": ", to_string(val)]

  defp warning_value({:row_estimation, under_or_over, val}) do
    ["Rows ", under_or_over, " by ", to_string(val), "x"]
  end

  defimpl Kino.Render, for: KinoEcto.Explain.Postgres do
    def to_livebook(explain) do
      plan =
        explain
        |> KinoEcto.Explain.Postgres.Renderer.build_graph()
        |> Kino.Mermaid.new()

      if is_nil(explain.raw) do
        Kino.Render.to_livebook(plan)
      else
        [Plan: plan, Raw: explain.raw]
        |> Kino.Layout.tabs()
        |> Kino.Render.to_livebook()
      end
    end
  end
end
