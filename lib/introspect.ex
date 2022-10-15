defmodule Lively.Introspect do
  def call(struct), do: introspect_fields(struct, assocs(struct))

  defp introspect_fields(struct, assocs) do
    struct_name = inspect(struct)

    struct.__schema__(:fields)
    |> Enum.map(fn field -> {field, struct.__schema__(:type, field)} end)
    |> Enum.map(fn {field, type} ->
      case Enum.find(assocs, fn {_, _, owner_key, _, _} -> field == owner_key end) do
        nil ->
          {struct_name, field, type}

        {field, inner_struct, type, relationship, cardinality} ->
          case halt?(assocs(inner_struct), struct) do
            true ->
              nil

            false ->
              {struct_name, field, call(inner_struct), type, relationship, cardinality}
          end
      end
    end)
    |> Enum.reject(&is_nil/1)
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
