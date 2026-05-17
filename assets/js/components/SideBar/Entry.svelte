<script lang="ts">
  import { isActive } from '~/router.ts';
  import type { Snippet } from "svelte";

  type Props = {
    href: Parameters<typeof isActive>[0];
    children: Snippet;
  };

  const { href, children }: Props = $props();
  const active = $derived(isActive.startsWith(href));
</script>

<a
  {href}
  class={[
    "group flex flex-row w-full items-center justify-start gap-4 px-3 py-2.5 rounded-md hover:bg-hairline transition-colors",
    "outline-none focus-visible:ring-2 focus-visible:ring-offset-1 focus-visible:ring-ink",
    { "bg-ink hover:text-muted": active },
  ]}
>
  <div class={["w-1 h-1 rounded-full group-hover:bg-muted", active ? "group-hover:bg-muted bg-paper" : "bg-muted"]}></div>
  <span class={["font-sans text-sm text-ink tracking-wide transition-colors", { "text-paper group-hover:text-ink": active }]}>
    {@render children()}
  </span>
</a>
