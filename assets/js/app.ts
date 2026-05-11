import { createInertiaApp } from "@inertiajs/svelte";
import { mount } from "svelte";
import { togglePlay } from "~/stores/player";

createInertiaApp({
  async resolve(name) {
    return await import(`./pages/${name}.svelte`);
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
