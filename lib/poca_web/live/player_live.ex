defmodule PocaWeb.PlayerLive do
  @moduledoc false
  use PocaWeb, :live_view

  def render(assigns) do
    ~H"""
    <div
      id="global-player"
      class="grid grid-cols-[44px_1fr_auto] absolute bottom-20 left-3 right-3 border border-hairline px-2.5 py-2 z-50 shadow-[0_4px_16px_rgba(0,0,0,0.08)]"
      phx-hook=".GlobalPlayer"
    >
      <div>
        <img />
      </div>
      <div>
        <p class="text-sm text-center text-base-content/70">Global Player</p>
      </div>
      <div class="bg-base-100 border-t border-base-content/10">
        <audio control class="w-full mt-2" />
      </div>
    </div>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".GlobalPlayer">
      document.addEventListener('DOMContentLoaded', () => {
        let count = 0;
        const player = document.getElementById('global-player');

        setInterval(() => {
          count += 1;
          console.log(`Global Player Count: ${count}`);
        }, 10000);
      });
    </script>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end
end
