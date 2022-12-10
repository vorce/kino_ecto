defmodule KinoEcto.QueryBuilder.Domain.Customer do
  use Ecto.Schema

  schema "customers" do
    field(:name, :string)
    field(:age, :string)
    has_many(:sales, KinoEcto.QueryBuilder.Domain.Sale)
  end
end
