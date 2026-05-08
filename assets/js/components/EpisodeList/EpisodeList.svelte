<script lang="ts">
  import Entry from "./Entry.svelte";

  type Props = {
    episodes: Episode[];
  };

  const { episodes }: Props = $props();
</script>

<div class="flex flex-col px-2 sm:px-4">
  {#each episodes as episode}
    <div class="py-2 sm:py-3 not-first:border-t border-hairline">
      <Entry {episode} />
    </div>
  {/each}
</div>
