import { createInertiaApp } from "@inertiajs/svelte";
import { mount } from "svelte";
import { togglePlay } from "~/stores/player";
import Layout from "~/components/Layout/Layout.svelte";

createInertiaApp({
  async resolve(name) {
    const page = await import(`./pages/${name}.svelte`);

    return {
      default: page.default,
      layout: page.layout || Layout,
    };
  },
  setup({ App, el, props }) {
    el && mount(App, { target: el, props });
  },
});

document.addEventListener("keydown", (event) => {
  const { code, target } = event;
  const isInputFocused = target instanceof HTMLElement && (target.tagName === "INPUT" || target.tagName === "TEXTAREA");

  if (code === "Space" && !isInputFocused) {
    event.preventDefault();
    togglePlay();
  }
});