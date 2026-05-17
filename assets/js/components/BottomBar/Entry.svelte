<script lang="ts">
  import { isActive } from "~/router.ts";
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
    "group flex flex-col w-full items-center justify-center gap-1 py-1 rounded-md hover:bg-hairline",
    "outline-none focus-visible:ring-2 focus-visible:ring-offset-1 focus-visible:ring-ink",
  ]}
>
  <div class={["w-1 h-1 rounded-full group-hover:bg-muted", { "bg-ink": active }]}></div>
  <span class={["font-sans text-sm text-ink tracking-wide transition-colors"]}>
    {@render children()}
  </span>
</a>
