import { createInertiaApp } from "@inertiajs/svelte";
import { mount } from "svelte";
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
