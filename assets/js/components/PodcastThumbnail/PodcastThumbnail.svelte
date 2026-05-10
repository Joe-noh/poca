<script lang="ts">
  type Props = {
    podcast: Podcast;
  };

  const { podcast }: Props = $props();
</script>

<a href={`/podcasts/${podcast.id}`} class="flex flex-col cursor-pointer">
  <img src={podcast.artworkUrl} alt={podcast.title} class="w-full aspect-square object-cover mb-2 rounded-md" />
  <p class="font-bold font-sans text-ink mb-1 truncate">{podcast.title}</p>
  <p class="text-sm font-sans text-muted truncate">{podcast.author}</p>
</a>
