<script lang="ts" module>
  export { default as layout } from "~/components/Layout/Layout.svelte";
</script>

<script lang="ts">
  import EpisodeList from "~/components/EpisodeList/EpisodeList.svelte";

  type Props = {
    episodes: Episode[];
  };

  const { episodes }: Props = $props();
</script>

<EpisodeList {episodes} />
