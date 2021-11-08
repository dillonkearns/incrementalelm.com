module.exports = {
  variants: [],
  theme: {
    extend: {
      colors: {
        background: "var(--background)",
        selectionBackground: "var(--selection-background)",
        foreground: "var(--foreground)",
        foregroundLight: "var(--foreground-light)",
        foregroundStrong: "var(--foreground-strong)",
        accent1: "var(--accent1)",
        accent2: "var(--accent2)",
        highlight: "var(--highlight)",
      },
    },
  },
  plugins: [
    require("@tailwindcss/typography"),
    // ...
  ],
};
