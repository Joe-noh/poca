defmodule PocaWeb.Viewport do
  @mobile_max_width 640 # Tailwind's "sm" breakpoint

  defmacro __using__(_) do
    quote do
      def handle_event("viewport_resize", viewport, socket) do
        device = viewport |> Map.get("width") |> PocaWeb.Viewport.device_type()
        socket = Phoenix.Component.assign(socket, :device, device)

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

  def device_type(width) do
    if is_integer(width) and width > @mobile_max_width do
      :desktop
    else
      :mobile
    end
  end
end
