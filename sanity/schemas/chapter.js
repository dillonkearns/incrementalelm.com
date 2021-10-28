export default {
  name: "chapter",
  type: "document",
  title: "Chapter",
  fields: [
    {
      name: "title",
      type: "string",
      title: "Title",
    },
    {
      name: "slug",
      type: "slug",
      title: "Slug",
      description: "What should the URL-friendly name of this episode be?",
      options: {
        source: "title",
        maxLength: 96,
      },
    },
    {
      name: "description",
      type: "text",
      title: "Episode Description",
      description: "For Google SEO, previews, etc. — a brief overview.",
    },
    {
      name: "video",
      type: "mux.video",
      title: "Video",
    },
  ],
};
