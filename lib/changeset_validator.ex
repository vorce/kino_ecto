defmodule Lively.ChangesetValidator do
  @moduledoc """
  Module for validating given arguments to a module changeset.
  """
  defstruct [:fun, :attrs]

  alias Lively.ChangesetValidator.Renderer

  def call(fun, attrs) do
    info = Function.info(fun)
    module = Keyword.get(info, :module)

    result = fun.(struct(module), attrs)

    Renderer.call(result)
  end
end
