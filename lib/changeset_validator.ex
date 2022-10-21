defmodule KinoEcto.ChangesetValidator do
  @moduledoc """
  Module for validating given arguments to a module changeset.
  """
  defstruct [:fun, :attrs]

  alias KinoEcto.ChangesetValidator.Renderer

  def call(%__MODULE__{fun: fun, attrs: attrs}), do: Renderer.call(apply(fun, attrs))
end
