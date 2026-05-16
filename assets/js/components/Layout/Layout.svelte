<script lang="ts">
  import type { Snippet } from "svelte";
  import NavLinks from "~/components/NavLinks/NavLinks.svelte";
  import Player from "~/components/Player/Player.svelte";
  import logo from "./logo.svg";

  type Props = {
    children: Snippet;
  };

  let { children }: Props = $props();
</script>

<main>
  <aside class="flex flex-row sm:flex-col border-hairline sm:gap-12 border-t sm:border-r sm:border-t-0 sm:p-6">
    <a href="/listen" class="w-8 h-8 hidden sm:block">
      <img src={logo} alt="POCA" class="w-full h-full" />
    </a>
    <NavLinks />
  </aside>
  <article class="flex-1 overflow-y-scroll">
    {@render children()}
  </article>
  <div class="player">
    <Player />
  </div>
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
        "nav player" auto / 13.5rem 1fr;
    }

    aside {
      grid-row: span 2;
    }
  }
</style>
