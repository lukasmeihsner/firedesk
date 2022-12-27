defmodule FiredeskWeb.DashboardLive do
  use FiredeskWeb, :live_view

  def render(assigns) do
    ~H"""
    <%= @current_path %>
    """
  end
end
