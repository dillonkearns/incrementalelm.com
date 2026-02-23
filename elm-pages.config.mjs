import { defineConfig } from "vite";
import elmTailwind from "elm-tailwind-classes/vite";
import tailwindcss from "@tailwindcss/vite";

export default {
  vite: defineConfig({
    plugins: [elmTailwind(), tailwindcss()]
  })
};
