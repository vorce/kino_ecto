defmodule Lively.ChangesetValidator do
  @moduledoc """
  Module for validating given arguments to a module changeset.
  """
  defstruct [:fun, :attrs]

  alias Lively.ChangesetValidator.Renderer

  def call(%__MODULE__{fun: fun, attrs: attrs}) do
    info = Function.info(fun)
    module = Keyword.get(info, :module)
    IO.inspect({info, module})
    result = fun.(struct(module), attrs)

    Renderer.call(result)
  end
end
