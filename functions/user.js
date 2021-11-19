const cookie = require("cookie");
const auth0Helpers = require("../src/auth0.js");

exports.handler =
  /**
   * @param {import('aws-lambda').APIGatewayProxyEvent} event
   * @param {any} context
   */
  async function (event, context) {
    const cookies = event.headers.cookie && cookie.parse(event.headers.cookie);
    const existingSession = cookies && cookies["incremental-elm-session"];
    const token =
      event.headers["Authorization"] || event.headers["authorization"];
    console.log("NEW session");
    if (token) {
      console.log("Updating cookie");
      const hour = 3600000;
      const twoWeeks = 14 * 24 * hour;
      const sessionCookie = cookie.serialize("incremental-elm-session", token, {
        secure: true,
        httpOnly: true,
        path: "/",
        maxAge: twoWeeks,
      });

      return {
        body: JSON.stringify(await buildUpUser(token)),
        headers: {
          "Content-Type": "application/json",
          "Set-Cookie": sessionCookie,
        },
        statusCode: 200,
      };
    } else if (existingSession) {
      return {
        body: JSON.stringify(await buildUpUser(existingSession)),
        headers: {
          "Content-Type": "application/json",
        },
        statusCode: 200,
      };
    } else {
      return {
        body: JSON.stringify({ reason: "No auth0 token provided" }),
        statusCode: 500,
      };
    }
  };

async function buildUpUser(auth0Token) {
  const userInfo = await auth0Helpers.getUserInfo(
    await auth0Helpers.getAuth0Sub(auth0Token)
  );
  const isPro = await auth0Helpers.isPro(auth0Token);
  return {
    isPro,
    nickname: userInfo.nickname,
    name: userInfo.name,
    picture: userInfo.picture,
  };
}
