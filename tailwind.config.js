module.exports = {
  variants: [],
  theme: {
    extend: {
      colors: {
        background: "var(--background)",
        selectionBackground: "var(--selection-background)",
        foreground: "var(--foreground)",
        foregroundStrong: "var(--foreground-strong)",
        accent1: "var(--accent1)",
        accent2: "var(--accent2)",
      },
    },
  },
  plugins: [
    require("@tailwindcss/typography"),
    // ...
  ],
};
