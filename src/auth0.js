const fetch = require("node-fetch");
const auth0Domain = "incrementalelm.us.auth0.com";

async function getAuth0Sub(auth0Token) {
  // TODO get this by base64 decoding instead of doing a fetch
  return fetch(`https://${auth0Domain}/userinfo`, {
    headers: {
      authorization: `Bearer ${auth0Token}`,
    },
  })
    .then((response) => response.json())
    .then((response) => {
      return response["sub"];
    });
}

async function getUserRoles(auth0Sub) {
  const managerToken = await getManagerToken();
  const response = await fetch(
    `https://${auth0Domain}/api/v2/users/${auth0Sub}/roles`,
    {
      headers: {
        authorization: `Bearer ${managerToken}`,
      },
    }
  );
  return await response.json();
}

async function getManagerToken() {
  var urlencoded = new URLSearchParams();
  urlencoded.append("grant_type", "client_credentials");
  urlencoded.append("client_id", process.env.AUTH0_CLIENT_ID);
  urlencoded.append("client_secret", process.env.AUTH0_CLIENT_SECRET);
  urlencoded.append("audience", `https://${auth0Domain}/api/v2/`);

  var requestOptions = {
    method: "POST",
    headers: {
      "content-type": "application/x-www-form-urlencoded",
    },
    body: urlencoded,
    redirect: "follow",
  };

  const request = await fetch(
    `https://${auth0Domain}/oauth/token`,
    requestOptions
  );
  return (await request.json()).access_token;
}

async function isPro(auth0Token) {
  const auth0Sub = await getAuth0Sub(auth0Token);
  const userRoles = await getUserRoles(auth0Sub);
  return userRoles.map((role) => role.id).includes("rol_6iAYZWVDyP4kGIM4");
}

async function getUserInfo(auth0Sub) {
  const managerToken = await getManagerToken();
  const response = await fetch(
    `https://${auth0Domain}/api/v2/users/${auth0Sub}`,
    {
      headers: {
        authorization: `Bearer ${managerToken}`,
      },
    }
  ).then((response) => response.json());
  return response;
}

async function getGithubUsername(auth0Sub) {
  const managerToken = await getManagerToken();
  const response = await fetch(
    `https://${auth0Domain}/api/v2/users/${auth0Sub}`,
    {
      headers: {
        authorization: `Bearer ${managerToken}`,
      },
    }
  ).then((response) => response.json());
  return response["nickname"];
}

module.exports = {
  getAuth0Sub,
  getUserRoles,
  isPro,
  getGithubUsername,
  getManagerToken,
  getUserInfo,
};
