import { createInertiaApp } from "@inertiajs/svelte";
import { mount } from "svelte";

createInertiaApp({
  async resolve(name) {
    return await import(`./pages/${name}.svelte`);
  },
  setup({ App, el, props }) {
    el && mount(App, { target: el, props });
  },
});
