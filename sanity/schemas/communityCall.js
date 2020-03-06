export default {
    name: 'communityCall',
    type: 'document',
    title: 'Community Call',
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
        name: 'agenda',
        type: 'markdown',
        title: 'Agenda',
      },
      {
        name: 'date',
        type: 'datetime',
        title: 'Episode Date',
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
        name: 'demo',
        type: 'url',
        title: 'Demo URL',
        description: 'Where can people see the result of this episode online?',
      },
      {
        name: 'repo',
        type: 'url',
        title: 'Repo URL',
        description: 'Where can people see the source code?',
      },
      {
        name: 'links',
        type: 'array',
        title: 'Links and Resources',
        description: 'Links to anything that was mentioned during the episode.',
        of: [{ type: 'url' }],
      },
      {
        name: 'transcript',
        type: 'markdown',
        title: 'Transcript',
        description: 'Get this from rev.com as a .txt file.',
      },
    ],
  };
  