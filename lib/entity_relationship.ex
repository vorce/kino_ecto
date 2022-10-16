defmodule Lively.EntityRelationship do
  defstruct [:schema]
  alias Lively.EntityRelationship.Renderer

  def call(%__MODULE__{schema: module}), do: Renderer.call(module)
end
