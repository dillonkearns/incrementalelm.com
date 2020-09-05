export default {
  name: 'guest',
  type: 'document',
  title: 'Guest',
  fields: [
    {
      name: 'name',
      type: 'string',
      title: 'Name',
    },
    {
      name: 'avatarUrl',
      type: 'image',
      title: 'Avatar URL',
    },
    {
      name: 'twitter',
      type: 'string',
      title: 'Twitter',
      description: 'Just the username, no @ or URL (e.g. dillontkearns).',
    },
    {
      name: 'github',
      type: 'string',
      title: 'Github',
      description: 'Just the username, no @ or URL (e.g. dillonkearns).',
    },
  ],
};
