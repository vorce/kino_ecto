defmodule Lively.Explain.Renderer do
  @moduledoc """
  Kino renderer for `Lively.Explain` structs

  Draws a graph of the query plan, inspired by: https://explain.dalibo.com/
  """
  alias Lively.Explain.Node

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
      classDef default text-align: left;
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

    defp node_value(%Node{} = node) do
      node_details = if is_nil(node.details), do: "", else: "<br><span>#{sanitize(node.details)}</span>"

      meta_items = Enum.map(node.meta, fn kv -> "<li>#{meta_value(kv)}</li>" end)
      node_meta = if node.meta == [], do: "", else: "<small><ul>#{meta_items}</ul></small>"
      "#{node.type}#{node_details}#{node_meta}"
    end

    defp sanitize(string) do
      string
      |> String.replace("(", "")
      |> String.replace(")", "")
    end

    defp meta_value({:timing, timing_ms}), do: "timing: #{timing_ms}ms"
    defp meta_value({key, val}), do: "#{key}: #{val}"
  end
end
