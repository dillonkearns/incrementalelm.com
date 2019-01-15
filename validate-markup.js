const { Elm } = require("./markup.js");

const app = Elm.ValidateMarkup.init();

app.ports.showMarkupError.subscribe(context => {
  console.log("Failed!");
  console.log(context);
  process.exit(1);
});

app.ports.success.subscribe(() => {
  console.log("Success!");
  process.exit(0);
});
