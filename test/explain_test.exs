defmodule KinoEcto.ExplainTest do
  use ExUnit.Case, async: true

  alias KinoEcto.Explain
  alias KinoEcto.Test.Support.ExplainData

  test "return error on unsupported adapter" do
    defmodule TestRepo do
      use Ecto.Repo,
        otp_app: :tiger,
        adapter: ExplainData.FakeAdapter
    end

    assert Explain.call(TestRepo, :all, nil) == {:error, {:unsupported_adapter, ExplainData.FakeAdapter}}
  end
end
