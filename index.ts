type ElmPagesInit = {
  load: (elmLoaded: Promise<unknown>) => Promise<void>;
  flags: unknown;
};

const config: ElmPagesInit = {
  load: async function (elmLoaded) {
    const app = await elmLoaded;
  },
  flags: function () {
    return {
      darkMode:
        localStorage.getItem("darkMode") ||
        (window.matchMedia("(prefers-color-scheme: dark)").matches
          ? "dark"
          : "light"),
    };
  },
};

export default config;
