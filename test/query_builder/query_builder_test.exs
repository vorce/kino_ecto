defmodule KinoEcto.QueryBuilderTest do
  use ExUnit.Case

  import Ecto.Query

  alias KinoEcto.QueryBuilder

  test "parses simple query" do
    query = "SELECT name, age FROM customers"
    result = QueryBuilder.call(query)

    dbg()
    IO.inspect(result)
  end
end
