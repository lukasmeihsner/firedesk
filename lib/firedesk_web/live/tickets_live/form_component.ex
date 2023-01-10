defmodule FiredeskWeb.TicketLive.FormComponent do
  use FiredeskWeb, :live_component
  alias AshPhoenix.Form
  alias Firedesk.Support
  alias Firedesk.Support.Ticket

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Add a ticket</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@form}
        id="ticket-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :subject}} type="text" label="Subject" />
        <.input field={{f, :status}} type="text" label="Status" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Ticket</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{action: :new} = assigns, socket) do
    form =
      Ticket
      |> Form.for_create(:create, api: Support)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, form)}
  end

  def update(%{action: :edit, id: id} = assigns, socket) do
    form =
      Ticket
      |> Support.get!(id)
      |> Form.for_update(:update, api: Support)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, form)}
  end

  @impl true
  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("save", _, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "User updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, form} ->
        {:noreply, assign(socket, :form, form)}
    end
  end
end
