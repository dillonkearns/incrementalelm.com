import "./js/code-editor.js";
import "./lib/native-shim.js";
// import "https://unpkg.com/hls-video-element@0.0";
import "/hls-video-element.js";
import createAuth0Client from "https://cdn.skypack.dev/@auth0/auth0-spa-js";

export default {
  load: async function (elmLoaded) {
    // sendUserToElm(elmLoaded);
    applyDarkModeClass();

    const elmApp = await elmLoaded;
    elmApp.ports.toggleDarkMode.subscribe(toggleDarkMode);
  },
  flags: function () {
    return { darkMode: isDarkMode() };
  },
};

function isDarkMode() {
  return (
    localStorage.theme === "dark" ||
    (!("theme" in localStorage) &&
      window.matchMedia("(prefers-color-scheme: dark)").matches)
  );
}

function toggleDarkMode() {
  if (isDarkMode()) {
    localStorage.setItem("theme", "light");
  } else {
    localStorage.setItem("theme", "dark");
  }
  applyDarkModeClass();
}
function applyDarkModeClass() {
  if (isDarkMode()) {
    document.documentElement.classList.add("dark");
    document.documentElement.classList.remove("light");
  } else {
    document.documentElement.classList.add("light");
    document.documentElement.classList.remove("dark");
  }
}

async function sendUserToElm(elmLoaded) {
  const user = await getLogin();
  const elmApp = await elmLoaded;
  elmApp.ports.gotUser.send(user);
}

async function getLogin() {
  const hasSessionCookie = (await cookieStore.getAll()).some(
    (cookie) => cookie.name === "incremental-elm-session-active"
  );
  if (hasSessionCookie) {
    const firstTryUser = await fetch("/.netlify/functions/user", {}).then(
      (res) => res.json()
    );
    if (firstTryUser) {
      console.log("Got user from existing session");
      return firstTryUser;
    } else {
      console.log("ERROR: unable to get user from cookie");
    }
  }

  const auth0 = await createAuth0Client({
    domain: "incrementalelm.us.auth0.com",
    client_id: "b1mcTw8gNOptXDChhOMjcRCVCrw5MPke",
    audience: "https://db.fauna.com/db/ytc9s7k44ynrq",
  });

  try {
    const query = window.location.search;
    if (query.includes("code=") && query.includes("state=")) {
      await auth0.handleRedirectCallback();
      window.history.replaceState({}, document.title, "/");
      const authToken = await auth0.getTokenSilently();
      const user = await fetch("/.netlify/functions/user", {
        headers: {
          Authorization: authToken,
        },
      }).then((res) => res.json());
      return user;
    } else {
      const isAuthenticated = await auth0.isAuthenticated();
      if (isAuthenticated) {
        const authToken = await auth0.getTokenSilently();

        const user = await fetch("/.netlify/functions/user", {
          headers: {
            Authorization: authToken,
          },
        }).then((res) => res.json());
        return user;
      } else {
        auth0.loginWithRedirect({
          redirect_uri: window.location.origin,
        });
      }
    }
  } catch (e) {
    console.trace("ERROR", e);
  }
}
