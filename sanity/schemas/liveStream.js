export default {
    name: 'liveStream',
    type: 'document',
    title: 'Live Stream',
    fields: [
      {
        name: 'title',
        type: 'string',
        title: 'Title',
      },
      {
        title: 'Hide this episode on the website',
        name: 'hidden',
        type: 'boolean',
        options: { layout: 'checkbox' },
      },
      {
        name: 'slug',
        type: 'slug',
        title: 'Slug',
        description: 'What should the URL-friendly name of this episode be?',
        options: {
          source: 'title',
          maxLength: 96,
        },
      },
      {
        name: 'image',
        type: 'image',
        title: 'Image',
      },
      {
        name: 'description',
        type: 'text',
        title: 'Episode Description',
        description: 'For Google SEO, previews, etc. — a brief overview.',
      },
      {
        name: 'date',
        type: 'datetime',
        title: 'Episode Date',
      },
      {
        name: 'guest',
        type: 'array',
        title: 'Guest(s)',
        of: [{ type: 'reference', to: [{ type: 'guest' }] }],
      },
      {
        name: 'project',
        type: 'reference',
        title: 'Project',
        to: [{ type: 'project' }],
      },
      {
        name: 'youtubeID',
        type: 'string',
        title: 'YouTube ID',
        description: 'Just the ID, not the full URL.',
      },
      {
        name: 'repo',
        type: 'url',
        title: 'Repo URL',
        description: 'Where can people see the source code?',
      },
      {
        name: 'tags',
        type: 'array',
        title: 'Tags',
        options: {
          layout: 'tags'
        },
        of: [{ type: 'string' }],
      },
    ],
  };
  