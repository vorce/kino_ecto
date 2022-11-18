defmodule KinoEcto.QueryBuilderTest do
  use ExUnit.Case

  alias KinoEcto.QueryBuilder

  test "parses simple query" do
    query = "SELECT * FROM persons WHERE name = 'John'"

    IO.inspect(QueryBuilder.call(%QueryBuilder{sql_query: query}))
    IO.inspect(QueryBuilder.test(query))
  end

  test "parses simple with where" do
    _query = "SELECT name FROM persons WHERE name = 'John'"
  end
end
