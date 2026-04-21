import { debounce } from "es-toolkit";

export const ViewportResize = {
  mounted() {
    this.pushResizeEvent();

    const resizeHandler = debounce(() => this.pushResizeEvent(), 100);

    window.addEventListener("resize", resizeHandler);
  },

  pushResizeEvent() {
    this.pushEvent("viewport_resize", {
      width: window.innerWidth,
      height: window.innerHeight,
    });
  },
};
