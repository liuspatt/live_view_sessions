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

## USE
Add hook to block html  
```
<div 
  class=""
  phx-hook="StoreSettings"
>
```
### Clear
  ```
    push_event(socket, "clear", %{key: :storage_key_name})
  ```
### Restore
  Use in mount
  ```
    push_event(socket, "restore", %{key: :storage_key_name})
  ```
  ```
    def handle_event("storage_key_name_restore", token_data, socket) when is_binary(token_data) do
      {
        :noreply,
        socket
        |> assign(:storage_key_name, String.to_integer(restore_from_token(token_data)))
      }
    end
  ```

### store
  ```
    push_event(socket, "store", %{key: :storage_key_name, data: serialize_to_token(date)})
  ```

