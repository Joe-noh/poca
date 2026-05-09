<script lang="ts">
  import { Link } from "@inertiajs/svelte";
  import type { Snippet } from "svelte";

  type Props = {
    href: string;
    active?: boolean;
    children: Snippet;
  };

  const { href, active, children }: Props = $props();
</script>

<Link
  {href}
  class={[
    "group flex flex-col sm:flex-row w-full items-center justify-center sm:justify-start gap-1 sm:gap-4 sm:px-3 py-1 sm:py-2.5 rounded-md hover:bg-hairline sm:transition-colors",
    active ? "sm:bg-ink sm:hover:text-muted" : "",
  ]}
>
  <div
    class={[
      "w-1 h-1 rounded-full group-hover:bg-muted",
      active ? "bg-ink sm:group-hover:bg-muted sm:bg-paper" : "sm:bg-muted",
    ]}
  ></div>
  <span
    class={[
      "font-sans text-sm text-ink tracking-wide transition-colors",
      active ? "sm:text-paper" : "",
      active ? "sm:group-hover:text-ink" : "",
    ]}
  >
    {@render children()}
  </span>
</Link>
