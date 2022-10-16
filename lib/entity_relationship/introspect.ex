defmodule Lively.EntityRelationship.Introspect do
  def call(struct, acc \\ [])
  def call(%atom{} = struct, acc) when is_struct(struct), do: call(atom, acc)
  def call(struct, acc), do: introspect_fields(struct, assocs(struct), acc)

  defp introspect_fields(struct, assocs, acc) do
    struct.__schema__(:fields)
    |> Enum.map(fn field -> {field, struct.__schema__(:type, field)} end)
    |> Enum.reduce(acc, fn {field, type}, acc ->
      struct_name = inspect(struct)

      case Enum.find(assocs, fn {_, _, owner_key, _, _} -> field == owner_key end) do
        nil ->
          acc ++ [{struct_name, field, type}]

        {field, inner_struct, type, relationship, cardinality} ->
          case halt?(assocs(inner_struct), struct) do
            true ->
              acc

            false ->
              acc ++ [{struct_name, field, call(inner_struct), type, relationship, cardinality}]
          end
      end
    end)
  end

  defp assocs(struct) do
    struct.__schema__(:associations)
    |> Enum.map(&struct.__schema__(:association, &1))
    |> Enum.map(&{&1.field, &1.related, &1.owner_key, &1.relationship, &1.cardinality})
  end

  def halt?(assocs, parent) do
    Enum.any?(assocs, fn {_, assoc, _, _, _} -> assoc == parent end)
  end
end
