defmodule Lively.Explain do
  @moduledoc """
  Parse and render query explain results
  """
  defstruct [:plan, :execution_time, :planning_time]

  defmodule Node do
    defstruct [
      :type,
      :timing,
      :rows,
      :cost,
      children: []
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
    plan
    |> Map.get("Plans", [])
    |> Enum.reduce(%Node{type: Map.get(plan, "Node Type", "Unknown")}, fn child_plan, acc ->
      child_tree = build_tree(child_plan)

      if is_nil(child_tree) do
        acc
      else
        %Node{acc | children: [child_tree | acc.children]}
      end
    end)
  end

  defimpl Kino.Render, for: Lively.Explain do
    def to_livebook(explain) do
      context = """
      * Execution time: #{explain.execution_time}ms
      * Planning time: #{explain.planning_time}ms
      """

      lines = node_mermaid_lines(explain.plan, "T", "")

      graph = """
      ```mermaid
        graph TB
        #{lines}
      ```
      """

      content = """
      #{context}

      #{graph}
      """

      content
      |> Kino.Markdown.new()
      |> Kino.Render.to_livebook()
    end

    defp node_mermaid_lines(%Node{children: []}, _, acc), do: acc

    defp node_mermaid_lines(
           %Node{children: children, type: val},
           label,
           acc
         ) do
      lines =
        children
        |> Enum.with_index()
        |> Enum.reduce("", fn {child, index}, node_lines ->
          child_label = "#{label}#{index}"
          node_lines <> "\t#{label}(#{val})-->#{child_label}(#{child.type})\n"
        end)

      lines <>
        (children
         |> Enum.with_index()
         |> Enum.reduce("", fn {child, index}, child_lines ->
           child_label = "#{label}#{index}"
           child_lines <> node_mermaid_lines(child, child_label, acc)
         end))
    end
  end
end
