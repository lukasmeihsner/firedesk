defmodule FiredeskWeb.RouteAssigns do
  import Phoenix.Component
  import Phoenix.LiveView

  def on_mount(:default, _params, _session_, socket) do
    {
      :cont,
      socket |> attach_hook(:set_route_path, :handle_params, &update_current_path/3)
    }
  end

  defp update_current_path(_params, url, socket) do
    {:cont, assign(socket, current_path: URI.parse(url).path)}
  end
end
