defmodule FiredeskWeb.TicketLive.Index do
  use FiredeskWeb, :live_view
  alias Firedesk.Support.Ticket
  alias Firedesk.Support

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_tickets()

    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def render(assigns) do
    ~H"""
    <.header>
      Listing tickets
      <:actions>
        <.link patch={~p"/app/tickets/new"}>
          <.button>New Ticket</.button>
        </.link>
      </:actions>
    </.header>

    <.table id="tickets" rows={@tickets} row_click={&JS.navigate(~p"/app/tickets/#{&1}")}>
      <:col :let={ticket} label="Subject"><%= ticket.subject %></:col>
      <:col :let={ticket} label="Status"><%= ticket.status %></:col>
      <:action :let={ticket}>
        <div class="sr-only">
          <.link navigate={~p"/app/tickets/#{ticket}"}>Show</.link>
        </div>
        <.link patch={~p"/app/tickets/#{ticket}/edit"}>Edit</.link>
      </:action>
      <:action :let={ticket}>
        <.link phx-click={JS.push("delete", value: %{id: ticket.id})} data-confirm="Are you sure?">
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="ticket-modal"
      show
      on_cancel={JS.navigate(~p"/app/tickets")}
    >
      <.live_component
        module={FiredeskWeb.TicketLive.FormComponent}
        id={@ticket.id || :new}
        title={@page_title}
        action={@live_action}
        navigate={~p"/app/tickets"}
      />
    </.modal>
    """
  end

  def handle_event("delete", %{"id" => id}, socket) do
    ticket = Support.get!(Ticket, id)
    Support.destroy!(ticket)

    {:noreply, assign_tickets(socket)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Ticket")
    |> assign(:ticket, Support.get!(Ticket, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Ticket")
    |> assign(:ticket, %Ticket{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tickts")
    |> assign(:ticket, nil)
  end

  defp assign_tickets(socket) do
    tickets =
      Ticket
      |> Support.read!()

    socket
    |> assign(tickets: tickets)
  end
end
