import { debounce } from "es-toolkit";

let resizeHandler;

export const ViewportResize = {
  mounted() {
    this.pushResizeEvent();

    resizeHandler = debounce(() => this.pushResizeEvent(), 100);

    window.addEventListener("resize", resizeHandler);
  },

  destroyed() {
    window.removeEventListener("resize", resizeHandler);
  },

  pushResizeEvent() {
    this.pushEvent("viewport_resize", {
      width: window.innerWidth,
      height: window.innerHeight,
    });
  },
};
