defmodule KinoEcto.QueryBuilder do
  defstruct [:sql_query]
  import Ecto.Query
  alias KinoEcto.QueryBuilder.Renderer

  defmodule Customer do
    use Ecto.Schema

    import Ecto.Query

    schema "customers" do
      field(:name, :string)
      field(:age, :string)
    end
  end

  # def call(%__MODULE__{sql_query: query}) do
  #   query = String.downcase(query)
  #   {:ok, tokens, _} = :build_query_lexer.string(query)
  #   {:ok, ast} = :build_query_parser.parse(tokens)
  #   ast
  # end

  defmodule KinoEcto.QueryBuilder.Node do
    defstruct [:name, :value, :lhs, :rhs]
  end

  def call(query) do
    query =
      query
      |> String.downcase()
      |> String.to_charlist()

    {:ok, tokens, _} = :build_query_lexer.string(query)
    {:ok, ast} = :build_query_parser.parse(tokens)

    ast
    |> cleanup()
    |> build_query()

    # [:select, [:fields, [:all]], [:from, ["customers"]]]
    # [:select, [:fields, ["name", "age"]], [:from, ["customers"]]]
  end

  defp cleanup(ast) when is_tuple(ast) do
    ast
    |> Tuple.to_list()
    |> Enum.map(&cleanup/1)
    |> Enum.reject(&is_nil/1)
  end

  defp cleanup(ast) when is_list(ast), do: to_string(ast)
  defp cleanup(ast), do: ast

  defp build_query(ast) do
    ast
    |> Enum.reduce(%Ecto.Query{}, fn item, acc ->
      acc = do_build_query(item, acc)
      acc
    end)
  end

  defp do_build_query(:select, query), do: query

  defp do_build_query([:fields, fields], query) do
    flatten_fields = List.flatten(fields) |> Enum.map(&String.to_atom/1)

    query
    |> select(^flatten_fields)
  end

  defp do_build_query([:from, [table]], query) do
    query
    |> build_from(table)
  end

  defp build_from(query, from_part) do
    result = %{
      query
      | from: %Ecto.Query.FromExpr{
          source: get_source(from_part)
        }
    }

    result
  end

  defp build_where(query, [_where, field_name, "=" | tail]) do
    tail = tail |> Enum.join() |> String.replace("'", "")

    query
    |> where([t], field(t, ^String.to_atom(field_name)) == ^tail)
  end

  defp get_source(table_name) do
    {:ok, modules} = :application.get_key(:kino_ecto, :modules)

    modules
    |> Enum.reject(fn item -> item == :build_query_lexer || item == :build_query_parser end)
    |> Enum.filter(&({:__schema__, 1} in &1.__info__(:functions)))
    |> Enum.find(fn module -> module.__schema__(:source) == table_name end)
    |> then(fn schema -> {table_name, schema} end)
  end

  # defimpl Ecto.Queryable, for: KinoEcto.QueryBuilder do
  #   def to_query(query_builder) do
  #     [fields | tail] =
  #       query_builder.sql_query
  #       |> String.split("from")

  #     translate_query(tail)
  #   end

  #   defp translate_query(query) do
  #     [table_name | tail] = String.split(" ") |> Enum.map(&String.trim/1)

  #     table_name
  #     |> build_query()
  #     |> add_join(tail)
  #     |> add_where(tail)
  #   end

  #   defp build_query(table_name) do
  #     %Ecto.Query{from: %Ecto.Query.FromExpr{source: get_source(table_name)}}
  #   end

  #   defp add_join(ecto_query, query) do
  #     ecto_query
  #   end

  #   defp add_where(ecto_query, query) do
  #     %Ecto.Query.BooleanExpr{
  #   end

  # defp get_source(table_name) do
  #   {:ok, modules} = :application.get_key(:kino_ecto, :modules)

  #   modules
  #   |> Enum.filter(&({:__schema__, 1} in &1.__info__(:functions)))
  #   |> Enum.find(fn module -> module.__schema__(:source) == table_name end)
  #   |> IO.inspect()
  #   |> then(fn schema -> {table_name, schema} end)
  # end
  # end
end
