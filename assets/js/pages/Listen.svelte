<script lang="ts">
  import EpisodeList from "~/components/EpisodeList/EpisodeList.svelte";

  type Props = {
    episodes: Episode[];
  };

  const { episodes }: Props = $props();
</script>

<EpisodeList {episodes} />
