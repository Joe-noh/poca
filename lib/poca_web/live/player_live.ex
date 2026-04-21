defmodule PocaWeb.PlayerLive do
  @moduledoc false
  use PocaWeb, :live_view

  def render(assigns) do
    ~H"""
    <div id="global-player" class="fixed bottom-0 left-0 right-0 z-50" phx-hook=".GlobalPlayer">
      <div class="bg-base-100 border-t border-base-content/10">
        <div class="container mx-auto px-4 py-2">
          <p class="text-sm text-center text-base-content/70">Global Player Placeholder</p>
          <audio control class="w-full mt-2" />
        </div>
      </div>
    </div>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".GlobalPlayer">
      // Example JavaScript to handle global player interactions
      document.addEventListener('DOMContentLoaded', () => {
        let count = 0;
        const player = document.getElementById('global-player');

        setInterval(() => {
          count += 1;
          console.log(`Global Player Count: ${count}`);
        }, 1000);
      });
    </script>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end
end
