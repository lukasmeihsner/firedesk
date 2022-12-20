defmodule Firedesk.Support.Registry do
  use Ash.Registry,
    extensions: [
      # This extension adds helpful compile time validations
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry Firedesk.Support.Ticket
    entry Firedesk.Support.Representative
  end
end
