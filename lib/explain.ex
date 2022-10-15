defmodule Lively.Explain do
  @moduledoc """
  Parse and render query explain results
  """
  defstruct [:plan, :execution_time, :planning_time]

  defmodule Node do
    defstruct [
      :type,
      :left,
      :right,
      :timing,
      :rows,
      :cost
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
    %Node{
      type: Map.get(plan, "Node Type", "Unknown"),
      left: plan |> Map.get("Plans", []) |> List.first() |> build_tree(),
      right: plan |> Map.get("Plans", []) |> Enum.at(1) |> build_tree()
    }
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

    defp node_mermaid_lines(
           %Node{left: %Node{} = left, right: %Node{} = right, type: val},
           label,
           acc
         ) do
      left_label = label <> "L"
      right_label = label <> "R"

      line =
        "\t#{label}((#{val}))-->#{left_label}((#{left.type}))\n" <>
          "\t#{label}-->#{right_label}((#{right.type}))\n"

      line <>
        node_mermaid_lines(left, left_label, acc) <>
        node_mermaid_lines(right, right_label, acc)
    end

    defp node_mermaid_lines(%Node{left: nil, right: nil}, _, acc), do: acc

    defp node_mermaid_lines(
           %Node{left: %Node{} = left, right: nil, type: val},
           label,
           acc
         ) do
      left_label = label <> "L"
      line = "\t#{label}((#{val}))-->#{left_label}((#{left.type}))\n"
      line <> node_mermaid_lines(left, left_label, acc)
    end

    defp node_mermaid_lines(
           %Node{left: nil, right: %Node{} = right, type: val},
           label,
           acc
         ) do
      right_label = label <> "R"
      line = "\t#{label}((#{val}))-->#{right_label}((#{right.type}))\n"
      line <> node_mermaid_lines(right, right_label, acc)
    end
  end
end
