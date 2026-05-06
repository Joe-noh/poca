<script lang="ts">
  import Entry from "./Entry.svelte";

  type Props = {
    activeTab: "listen" | "library" | "queue" | "search";
  };

  const { activeTab }: Props = $props();
</script>

<nav class="flex-1 flex flex-row sm:flex-col gap-1 sm:gap-2.5">
  <Entry href="/listen" active={activeTab === "listen"}>Home</Entry>
  <Entry href="/library" active={activeTab === "library"}>Library</Entry>
  <Entry href="/queue" active={activeTab === "queue"}>Queue</Entry>
  <Entry href="/search" active={activeTab === "search"}>Search</Entry>
</nav>
