<script lang="ts">
  import { HouseIcon, BooksIcon, QueueIcon, MagnifyingGlassIcon } from "phosphor-svelte";
  import Entry from "./Entry.svelte";
</script>

<div class="sticky bottom-0 bg-paper z-20 border-t border-hairline sm:hidden">
  <nav class="flex-1 flex flex-row h-14 gap-1">
    <Entry href="/listen" icon={HouseIcon}>Home</Entry>
    <Entry href="/library" icon={BooksIcon}>Library</Entry>
    <Entry href="/queue" icon={QueueIcon}>Queue</Entry>
    <Entry href="/search" icon={MagnifyingGlassIcon}>Search</Entry>
  </nav>
</div>
