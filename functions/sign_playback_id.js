const { signPlaybackId } = require("../src/mux_signatures");
const { getSession } = require("../src/session.js");
const auth0Helpers = require("../src/auth0.js");

async function isPaidVideo(event) {
  return false;
}

module.exports.handler = async (event, context) => {
  if (await isPaidVideo(event)) {
    const auth0Token = getSession(event);
    if (!auth0Token) {
      return {
        statusCode: 401,
        body: JSON.stringify({ error: "Not logged in." }),
      };
    }
    const isPro = await auth0Helpers.isPro(auth0Token);
    if (!isPro) {
      return {
        statusCode: 403,
        body: JSON.stringify({
          error: "You need a pro account to access this video.",
        }),
      };
    }
  }

  try {
    const { queryStringParameters } = event;
    const { playbackId } = queryStringParameters;
    if (!playbackId) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          errors: [{ message: "Missing playbackId in query string" }],
        }),
      };
    }
    const token = await signPlaybackId(playbackId);
    return {
      statusCode: 302,
      headers: {
        "Access-Control-Allow-Origin": "*",
        location: `https://stream.mux.com/${playbackId}.m3u8?token=${token}`,
      },
      body: "",
    };
  } catch (e) {
    console.error("ERROR", e);
    return {
      statusCode: 500,
      body: JSON.stringify({ errors: [{ message: "Server Error" }] }),
    };
  }
};
