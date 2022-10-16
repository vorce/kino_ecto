defmodule Lively.ChangesetValidatorTest do
  use ExUnit.Case

  alias Lively.ChangesetValidator

  defmodule TestUser do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
      field :name, :string
      field :age, :integer, default: 0
      field :email, :string
    end

    def changeset(user, attrs) do
      user
      |> cast(attrs, [:name, :age, :email])
      |> validate_required(:name)
      |> validate_format(:email, ~r/@/)
      |> validate_inclusion(:age, 18..100)
    end

    def another_changeset(user, attrs) do
      user
      |> cast(attrs, [:name, :age, :email])
      |> validate_required(:name)
      |> validate_format(:email, ~r/@/)
      |> validate_inclusion(:age, 21..100)
    end
  end

  test "renders evaluated changeset for given set of inputs for a module" do
    args = %{
      name: "John",
      age: -1,
      email: "this.is.wrong.com"
    }

    assert %Kino.Markdown{content: _content} = Kino.Render.to_livebook(%ChangesetValidator{fun: &TestUser.changeset/2, attrs: args})
    # assert content.errors == [{:age, {"is invalid", [validation: :inclusion, enum: 18..100]}}, {:email, {"has invalid format", [validation: :format]}}]
    # assert content.valid? == false
  end

  test "renders another evaluated changeset for given set of inputs for a module" do
    args = %{
      name: "John",
      age: 18,
      email: "john@email.com"
    }

    assert %Kino.Markdown{content: _content} = Kino.Render.to_livebook(%ChangesetValidator{fun: &TestUser.another_changeset/2, attrs: args})
    # assert content.errors == [age: {"is invalid", [validation: :inclusion, enum: 21..100]}]
    # assert content.valid? == false
  end
end
