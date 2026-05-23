<script lang="ts">
  import type { Component } from "svelte";
  import { isActive } from "~/router.ts";
  import type { Snippet } from "svelte";

  type Props = {
    href: Parameters<typeof isActive>[0];
    icon: Component;
    children: Snippet;
  };

  const { href, icon: Icon, children }: Props = $props();
  const active = $derived(isActive.startsWith(href));
</script>

<a
  {href}
  class={[
    "group flex flex-col w-full items-center justify-center gap-1 py-1 rounded-md hover:bg-hairline",
    "outline-none focus-visible:ring-2 focus-visible:ring-offset-1 focus-visible:ring-ink",
  ]}
>
  <Icon size={16} weight={active ? "fill" : "regular"} class={active ? "text-ink" : "text-muted"} />
  <span class={["font-serif text-sm text-ink tracking-wide transition-colors"]}>
    {@render children()}
  </span>
</a>
