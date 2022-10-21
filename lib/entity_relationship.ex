defmodule KinoEcto.EntityRelationship do
  defstruct [:schema]

  alias KinoEcto.EntityRelationship.Introspect
  alias KinoEcto.EntityRelationship.Renderer

  def call(%__MODULE__{schema: module}) do
    module
    |> Introspect.call()
    |> Renderer.call()
  end
end
