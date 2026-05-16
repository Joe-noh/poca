import App from "./App.svelte";
import { mount } from "svelte";
import { togglePlay } from "~/stores/player";

document.addEventListener("keydown", (event) => {
  const { code, target } = event;
  const isInputFocused = target instanceof HTMLElement && (target.tagName === "INPUT" || target.tagName === "TEXTAREA");

  if (code === "Space" && !isInputFocused) {
    event.preventDefault();
    togglePlay();
  }
});

document.addEventListener("DOMContentLoaded", () => {
  const el = document.getElementById("app");

  el && mount(App, { target: el });
});
