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
    "group flex flex-col sm:flex-row w-full items-center justify-center sm:justify-start gap-1 sm:gap-4 sm:px-3 py-1 sm:py-2.5 rounded-md hover:bg-hairline sm:transition-colors",
    "outline-none focus-visible:ring-2 focus-visible:ring-offset-1 focus-visible:ring-ink",
    { "sm:bg-ink sm:hover:text-muted": active },
  ]}
>
  <div class={["w-1 h-1 rounded-full group-hover:bg-muted", active ? "bg-ink sm:group-hover:bg-muted sm:bg-paper" : "sm:bg-muted"]}></div>
  <span class={["font-sans text-sm text-ink tracking-wide transition-colors", { "sm:text-paper sm:group-hover:text-ink": active }]}>
    {@render children()}
  </span>
</a>
