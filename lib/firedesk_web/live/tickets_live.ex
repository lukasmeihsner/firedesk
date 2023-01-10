defmodule FiredeskWeb.TicketsLive do
  use FiredeskWeb, :live_view
  alias Firedesk.Support.Ticket
  alias Firedesk.Support

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_tickets()

    {:ok, socket}
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      Listing Tickets
      <:actions>
        <.link patch={~p"/app/tickets/new"}>
          <.button>New Ticket</.button>
        </.link>
      </:actions>
    </.header>

    <.table id="tickets" rows={@tickets}>
      <:col :let={ticket} label="Id"><%= ticket.id %></:col>
      <:col :let={ticket} label="Subject"><%= ticket.subject %></:col>
      <:col :let={ticket} label="Status"><%= ticket.status %></:col>
      <:action>
        <p>Open</p>
        <p>Edit</p>
        <p>Delete</p>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="new-ticket"
      show
      on_cancel={JS.navigate(~p"/app/tickets")}
    >
    </.modal>
    """
  end

  defp assign_tickets(socket) do
    tickets =
      Ticket
      |> Support.read!()

    socket
    |> assign(tickets: tickets)
  end
end
