defmodule Lively.EntityRelationship do
  defstruct [:schema]

  alias Lively.EntityRelationship.Introspect
  alias Lively.EntityRelationship.Renderer

  def call(%__MODULE__{schema: module}) do
    module
    |> Introspect.call()
    |> Renderer.call()
  end
end
