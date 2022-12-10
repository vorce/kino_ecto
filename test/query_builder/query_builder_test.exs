defmodule KinoEcto.QueryBuilderTest do
  use ExUnit.Case

  import Ecto.Query

  alias KinoEcto.QueryBuilder

  test "parses simple query" do
    query = "SELECT name, age FROM customers"
    result = QueryBuilder.call(query)

    expected_query = from(c in KinoEcto.QueryBuilder.Domain.Customer, select: [:name, :age])

    assert result.from.source == expected_query.from.source
    assert result.select.take == expected_query.select.take
  end

  test "parses simple query with all fields" do
    query = "SELECT * FROM customers"
    result = QueryBuilder.call(query)

    expected_query = from(c in KinoEcto.QueryBuilder.Domain.Customer)

    assert result.from.source == expected_query.from.source
    assert is_nil(result.select)
    assert is_nil(expected_query.select)
  end

  test "parses query with join" do
    query = "SELECT * FROM sales JOIN customers ON sales.customer_id = customers.id"
    result = QueryBuilder.call(query)

    expected_query =
      from(s in KinoEcto.QueryBuilder.Domain.Sale,
        join: c in KinoEcto.QueryBuilder.Domain.Customer,
        on: s.customer_id == c.id
      )

    IO.inspect(result)
    # assert result.from.source == expected_query.from.source
    # assert is_nil(result.select)
    # assert is_nil(expected_query.select)
  end
end
