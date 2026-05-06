<script lang="ts">
  import type { Snippet } from "svelte";
  import { Link } from "@inertiajs/svelte";
  import NavLinks from "~/components/NavLinks/NavLinks.svelte";

  type Props = {
    activeTab: "listen" | "library" | "queue" | "search";
    children: Snippet;
  };

  let { activeTab, children }: Props = $props();
</script>

<main>
  <aside class="flex flex-row sm:flex-col border-hairline sm:gap-12 border-t sm:border-r sm:border-t-0 sm:p-7">
    <Link href="/" class="w-8 h-8 hidden sm:block">
      <svg
        class="w-full h-full"
        viewBox="0 0 128 128"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        <rect width="128" height="128" rx="64" fill="#F4F0EA" />
        <path
          fill-rule="evenodd"
          clip-rule="evenodd"
          d="M108.8 0C119.404 0 128 8.59613 128 19.2V108.8C128 119.404 119.404 128 108.8 128H19.2C8.59613 128 4.12337e-07 119.404 0 108.8V19.2C0 8.59613 8.59613 4.12325e-07 19.2 0H108.8ZM35.2 78.4C27.2471 78.4 20.8 84.8471 20.8 92.8C20.8 100.753 27.2471 107.2 35.2 107.2C43.1529 107.2 49.6 100.753 49.6 92.8C49.6 84.8471 43.1529 78.4 35.2 78.4ZM92.8 78.4C84.8471 78.4 78.4 84.8471 78.4 92.8C78.4 100.753 84.8471 107.2 92.8 107.2C100.753 107.2 107.2 100.753 107.2 92.8C107.2 84.8471 100.753 78.4 92.8 78.4ZM88 20.8C77.3962 20.8001 68.8 29.3962 68.8 40C68.8001 50.6037 77.3963 59.2 88 59.2C98.6038 59.2 107.2 50.6038 107.2 40C107.2 29.3961 98.6039 20.8 88 20.8Z"
          fill="#141311"
        />
      </svg>
    </Link>
    <NavLinks {activeTab} />
  </aside>
  <article class="flex-1 p-2 overflow-y-scroll">
    {@render children()}
  </article>
  <div class="player">Player</div>
</main>

<style>
  main {
    height: 100vh;
    display: grid;
    grid-template:
      "main" 1fr
      "player" auto
      "nav" 48px / 1fr;
  }

  aside {
    grid-area: nav;
  }

  article {
    grid-area: main;
  }

  .player {
    grid-area: player;
  }

  @media (width >= 40rem) {
    main {
      grid-template:
        "nav main" 1fr
        "nav player" auto / 240px 1fr;
    }

    aside {
      grid-row: span 2;
    }
  }
</style>
