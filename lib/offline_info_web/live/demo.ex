defmodule OfflineInfoWeb.DemoLive do
  use OfflineInfoWeb, :live_view
  alias Cipher

  def render(assigns) do
    ~H"""
    <div id="hook" phx-hook="Storage" class="space-y-12 divide-y sm:mx-0 mx-4">
      <div class="text-4xl">
        <%= @data %>
      </div>
      <hr />
      <div class="flex flex-col">
        <button phx-click="button_with_data" phx-value-data="some_data_to_save">Set html data</button>
        <button phx-click="button_object">Set Data Object</button>
        <button phx-click="button_clear">Clear</button>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:data, nil)
     |> push_event("restore", %{key: :data, event: "data_restore"})}
  end

  # session handling
  defp clear_browser_storage(socket) do
    push_event(socket, "clear", %{key: socket.assigns.my_storage_key})
  end

  def handle_event("data_restore", token_data, socket) when is_binary(token_data) do
    IO.inspect(token_data, label: "token_data")

    {
      :noreply,
      socket
      |> assign(:data, Cipher.decrypt(token_data))
    }
  end

  def handle_event("restoreSettings", _token_data, socket) do
    Logger.debug("No LiveView SessionStorage state to restore")
    {:noreply, socket}
  end

  # end session handling

  def handle_event("button_with_data", %{"data" => data} = _, socket) do
    {:noreply,
     socket
     |> assign(:data, data)
     |> push_event("store", %{
       key: :data,
       data: Cipher.encrypt(data)
     })}
  end

  def handle_event("button_object", _, socket) do
    data = [
      %{"data" => "info1"},
      %{"data" => "info2"},
      %{"data" => "info3"},
      %{"data" => "info4"},
      %{"data" => "info5"}
    ]

    json_data = Poison.encode!(data)

    {:noreply,
     socket
     |> assign(:data, json_data)
     |> push_event("store", %{
       key: :data,
       data: Cipher.encrypt(json_data)
     })}
  end


  def handle_event("button_clear", _, socket) do
    {:noreply,
     socket
     |> assign(:data, nil)
     |> push_event("clear", %{
       key: :data
     })}
  end
end
