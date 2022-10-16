defmodule Lively.ChangesetValidator do
  @moduledoc """
  Module for validating given arguments to a module changeset.
  """
  defstruct [:fun, :attrs]

  alias Lively.ChangesetValidator.Renderer

  def call(%__MODULE__{fun: fun, attrs: attrs}), do: Renderer.call(apply(fun, attrs))
end
