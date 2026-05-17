<script lang="ts">
  import Entry from "./Entry.svelte";
</script>

<div class="sticky bottom-0 bg-paper z-20 border-t border-hairline sm:hidden">
  <nav class="flex-1 flex flex-row h-12 gap-1">
    <Entry href="/listen">Home</Entry>
    <Entry href="/library">Library</Entry>
    <Entry href="/queue">Queue</Entry>
    <Entry href="/search">Search</Entry>
  </nav>
</div>
