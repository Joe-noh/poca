<script lang="ts">
  import Entry from "./Entry.svelte";

  type Props = {
    episodes: Episode[];
  };

  const { episodes }: Props = $props();
</script>

<div class="flex flex-col px-1 sm:px-3">
  {#each episodes as episode}
    <div class="py-1 sm:py-2 not-first:border-t border-hairline">
      <Entry {episode} />
    </div>
  {/each}
</div>
