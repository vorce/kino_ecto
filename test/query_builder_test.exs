defmodule Lively.QueryBuilderTest do
  use ExUnit.Case

  import Ecto.Query

  alias Lively.QueryBuilder

  test "parses simple query" do
    query = "SELECT * FROM persons WHERE name = 'John'"

    IO.inspect(QueryBuilder.call(query))
    IO.inspect(QueryBuilder.test(query))
  end

  test "parses simple with where" do
    query = "SELECT name FROM persons WHERE name = 'John'"
  end
end
