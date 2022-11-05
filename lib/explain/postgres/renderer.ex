defmodule KinoEcto.Explain.Postgres.Renderer do
  @moduledoc """
  Kino renderer for `KinoEcto.Explain.Postgres` structs

  Draws a graph of the query plan, inspired by: https://explain.dalibo.com/
  """
  alias KinoEcto.Explain.Postgres.Node

  def build_mermaid_graph(explain) do
    lines = node_mermaid_lines(explain.plan, "T", "")

    """
    graph TB
    subgraph Total
    TimeE[Execution time: #{explain.execution_time}ms]
    TimeP[Planning time: #{explain.planning_time}ms]
    end

    #{lines}
    classDef default text-align: left;
    """
  end

  defp node_mermaid_lines(%Node{children: []} = node, id, acc),
    do: acc <> "\n#{id}(#{node_value(node)})\n#{node_style(node, id)}"

  defp node_mermaid_lines(
         %Node{children: children} = node,
         id,
         acc
       ) do
    node_value = node_value(node)
    node_style = node_style(node, id)

    lines =
      children
      |> Enum.with_index()
      |> Enum.reduce("", fn {child, index}, node_lines ->
        child_id = "#{id}#{index}"
        child_value = node_value(child)
        node_lines <> "\t#{id}(#{node_value})-->#{child_id}(#{child_value})\n"
      end)
      |> Kernel.<>("#{node_style}")

    lines <>
      (children
       |> Enum.with_index()
       |> Enum.reduce("", fn {child, index}, child_lines ->
         child_id = "#{id}#{index}"
         child_lines <> node_mermaid_lines(child, child_id, acc)
       end))
  end

  defp node_value(%Node{} = node) do
    node_details = if is_nil(node.details), do: "", else: "<br><span>#{sanitize(node.details)}</span>"

    meta_items = Enum.map(node.meta, fn kv -> "<li>#{meta_value(kv)}</li>" end)
    node_meta = if node.meta == [], do: "", else: "<small><ul>#{meta_items}</ul></small>"

    node_warnings = if node.warnings == [], do: "", else: node.warnings |> Enum.map(&warning_value/1) |> Enum.join(" ")

    "#{node.type}#{node_details}#{node_meta}#{node_warnings}"
  end

  @warning_background_color "#f9d6a7"
  defp node_style(node, node_id) do
    if node.warnings == [] do
      ""
    else
      "style #{node_id} fill:#{@warning_background_color};\n"
    end
  end

  defp sanitize(string) do
    string
    |> String.replace("(", "")
    |> String.replace(")", "")
  end

  defp meta_value({:timing, timing_ms}), do: "timing: #{timing_ms}ms"
  defp meta_value({:cost, %{total: total, node: node}}), do: "cost: #{node}, total: #{total}"
  defp meta_value({key, val}), do: "#{key}: #{val}"

  defp warning_value({:row_estimation, under_or_over, val}) do
    "Rows #{under_or_over} by #{val}x"
  end

  defimpl Kino.Render, for: KinoEcto.Explain.Postgres do
    def to_livebook(explain) do
      plan =
        explain
        |> KinoEcto.Explain.Postgres.Renderer.build_mermaid_graph()
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
