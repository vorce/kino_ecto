defmodule KinoEcto.ChangesetValidatorTest do
  use ExUnit.Case

  alias KinoEcto.ChangesetValidator

  defmodule TestUser do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
      field(:name, :string)
      field(:age, :integer, default: 0)
      field(:email, :string)
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

    assert {:markdown, md} =
             Kino.Render.to_livebook(%ChangesetValidator{fun: &TestUser.changeset/2, attrs: [%TestUser{}, args]})

    assert md =~
             "**Changeset valid?** 🔴\n\n  **Errors:**\n* `age`: is invalid due to `inclusion` validation\n* `email`: has invalid format due to `format` validation\n\n"
  end

  test "renders another evaluated changeset for given set of inputs for a module" do
    args = %{
      name: "John",
      age: 18,
      email: "john@email.com"
    }

    assert {:markdown, md} =
             Kino.Render.to_livebook(%ChangesetValidator{fun: &TestUser.another_changeset/2, attrs: [%TestUser{}, args]})

    assert md =~ "**Changeset valid?** 🔴\n\n  **Errors:**\n* `age`: is invalid due to `inclusion` validation\n\n"
  end
end
