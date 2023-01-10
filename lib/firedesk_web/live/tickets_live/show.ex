defmodule FiredeskWeb.TicketLive.Show do
  use FiredeskWeb, :live_view

  alias Firedesk.Support
  alias Firedesk.Support.Ticket

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:ticket, Support.get!(Ticket, id))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Ticket <%= @ticket.id %>
      <:subtitle>This is a user record from your database.</:subtitle>
      <:actions>
        <.link patch={~p"/app/tickets/#{@ticket}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit user</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Name"><%= @ticket.subject %></:item>
      <:item title="Status"><%= @ticket.status %></:item>
    </.list>

    <.back navigate={~p"/app/tickets"}>Back to tickets</.back>

    <.modal
      :if={@live_action == :edit}
      id="user-modal"
      show
      on_cancel={JS.patch(~p"/app/tickets/#{@ticket}")}
    >
      <.live_component
        module={FiredeskWeb.TicketLive.FormComponent}
        id={@ticket.id}
        title={@page_title}
        action={@live_action}
        ticket={@ticket}
        navigate={~p"/app/tickets/#{@ticket}"}
      />
    </.modal>
    """
  end

  defp page_title(:show), do: "Show Ticket"
  defp page_title(:edit), do: "Edit Ticket"
end
