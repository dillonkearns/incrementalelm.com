const cookie = require("cookie");

module.exports = {
  getSession: function (event) {
    const cookies = event.headers.cookie && cookie.parse(event.headers.cookie);
    const session = cookies && cookies["incremental-elm-session"];
    return session;
  },
};
