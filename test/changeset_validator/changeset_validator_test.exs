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

    assert {
      :text,
      "%Lively.ChangesetValidator{\n  \e[34mfun:\e[0m &Lively.ChangesetValidatorTest.TestUser.changeset/2,\n  \e[34mattrs:\e[0m %{\e[34mage:\e[0m \e[34m-1\e[0m, \e[34memail:\e[0m \e[32m\"this.is.wrong.com\"\e[0m, \e[34mname:\e[0m \e[32m\"John\"\e[0m}\n}"
    } = Kino.Render.to_livebook(%ChangesetValidator{fun: &TestUser.changeset/2, attrs: args})
  end

  test "renders another evaluated changeset for given set of inputs for a module" do
    args = %{
      name: "John",
      age: 18,
      email: "john@email.com"
    }

    assert {
      :text,
      "%Lively.ChangesetValidator{\n  \e[34mfun:\e[0m &Lively.ChangesetValidatorTest.TestUser.another_changeset/2,\n  \e[34mattrs:\e[0m %{\e[34mage:\e[0m \e[34m18\e[0m, \e[34memail:\e[0m \e[32m\"john@email.com\"\e[0m, \e[34mname:\e[0m \e[32m\"John\"\e[0m}\n}"
    } = Kino.Render.to_livebook(%ChangesetValidator{fun: &TestUser.another_changeset/2, attrs: args})
  end
end
