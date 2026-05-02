defmodule PocaWeb.Viewport do
  @moduledoc """
  Provides an event handler for tracking the viewport size and assigning a device type to the socket.
  `use` this in each live views.

      use PocaWeb.Viewport
  """

  defmacro __using__(_) do
    quote do
      def handle_event("viewport_resize", viewport, socket) do
        device = viewport |> Map.get("width") |> PocaWeb.Viewport.device_type()
        Phoenix.Component.assign(socket, :device, device)

        {:noreply, socket}
      end
    end
  end

  def assign_device(socket) do
    device =
      socket.private
      |> get_in([:connect_params, "viewport", "width"])
      |> PocaWeb.Viewport.device_type()

    Phoenix.Component.assign(socket, :device, device)
  end

  def device_type(width) when is_integer(width) do
    # Tailwind's "sm" breakpoint
    if width > 640 do
      :desktop
    else
      :mobile
    end
  end

  def device_type(_), do: nil
end
