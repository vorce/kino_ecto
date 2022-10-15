defmodule Lively do
  defimpl Kino.Render, for: Atom do
    def to_livebook(atom) do
      case Code.ensure_loaded(atom) do
        {:error, :nofile} ->
          cond do
            application_with_supervisor?(atom) ->
              raw = Kino.Inspect.new(atom)
              tree = Kino.Process.app_tree(atom, direction: :left_right)
              tabs = Kino.Layout.tabs(Raw: raw, "Application tree": tree)
              Kino.Render.to_livebook(tabs)

            Kino.Utils.supervisor?(atom) ->
              raw = Kino.Inspect.new(atom)
              tree = Kino.Process.sup_tree(atom, direction: :left_right)
              tabs = Kino.Layout.tabs(Raw: raw, "Supervision tree": tree)
              Kino.Render.to_livebook(tabs)

            true ->
              Kino.Output.inspect(atom)
          end

        _ ->
          with struct when not is_nil(struct) <- atom.__info__(:struct),
               has_meta when not is_nil(has_meta) <-
                 Enum.any?(struct, fn %{field: field} -> field == :__meta__ end) do
            er =
              atom
              |> Lively.Visualize.call()

            tabs =
              Kino.Layout.tabs(Raw: Kino.Inspect.new(atom), "Entity Relationship Diagram": er)

            Kino.Render.to_livebook(tabs)
          else
            _ -> Kino.Output.inspect(atom)
          end
      end
    end

    defp application_with_supervisor?(name) do
      with master when master != :undefined <- :application_controller.get_master(name),
           {root, _application} when is_pid(root) <- :application_master.get_child(master),
           do: true,
           else: (_ -> false)
    end
  end
end
