defmodule KinoEcto.EntityRelationship.Renderer do
  def call(content) do
    content
    |> Enum.reduce([], &mermaid/2)
    |> Enum.uniq()
    |> Enum.join("\n")
    |> wrap()
    |> Kino.Markdown.new()
  end

  defp mermaid({struct, field, type}, acc) do
    class_def = "class `#{struct}`"
    type_def = "`#{struct}` : #{type} #{field}"
    acc ++ [class_def] ++ [type_def]
  end

  defp mermaid({struct, type, fields, field, relationship, cardinality}, acc) do
    relantionship =
      case {relationship, cardinality} do
        {:parent, :one} -> "\"0\" <|-- \"1\""
        {:parent, :many} -> "\"0\" <|-- \"*\""
        {:child, :one} -> "\"0\" --|> \"1\""
        {:child, :many} -> "\"0\" --|> \"*\""
        _ -> ".."
      end

    class_def = Enum.flat_map(fields, &mermaid(&1, []))
    relationship_def = fields |> Enum.map(&elem(&1, 0)) |> Enum.map(&"`#{struct}` #{relantionship} #{&1}")
    type_def = "`#{struct}` : #{type} #{field}"
    acc ++ class_def ++ relationship_def ++ [type_def]
  end

  defp wrap(spec),
    do: """
    ```mermaid
    classDiagram
    #{spec}
    ```
    """
end
