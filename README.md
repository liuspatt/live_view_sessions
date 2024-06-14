# Live view with session / cookies / localstorage
  * `mix phx.server` 

## Install 

  * add SessionStorage.js to /assets/vendor/SessionStorage.js
  * add hook in app.js
  ```
  import Storage from "../vendor/SessionStorage"
  const hooks = {
    Storage,

  }
  let liveSocket = new LiveSocket("/live", Socket, { hooks, params: { _csrf_token: csrfToken } })
  ```
  * add 

## Use 
