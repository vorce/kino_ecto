defmodule KinoEcto.Explain.Visualizer do
  @moduledoc false

  @callback options() :: Keyword.t()
  @callback new(any()) :: struct()
end
