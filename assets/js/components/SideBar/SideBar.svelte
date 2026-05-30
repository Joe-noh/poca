<script lang="ts">
  import Entry from "./Entry.svelte";
  import logo from "./logo.svg";
</script>

<aside class="flex-col border-hairline gap-12 border-r border-t-0 w-56 p-6 hidden sm:flex h-full sticky top-0">
  <a href="/listen" class="w-8 h-8">
    <img src={logo} alt="POCA" class="w-full h-full" />
  </a>
  <nav class="flex-1 flex flex-col gap-2.5 z-20">
    <Entry href="/listen">Home</Entry>
    <Entry href="/library">Library</Entry>
    <Entry href="/queue">Queue</Entry>
    <Entry href="/search">Search</Entry>
  </nav>
</aside>
