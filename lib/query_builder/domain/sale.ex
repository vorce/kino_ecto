defmodule KinoEcto.QueryBuilder.Domain.Sale do
  use Ecto.Schema

  schema "sales" do
    field(:total, :string)
    belongs_to(:customer, KinoEcto.QueryBuilder.Domain.Customer)
  end
end
