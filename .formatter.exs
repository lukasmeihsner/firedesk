[
  import_deps: [:phoenix, :ash, :ash_postgres],
  # uncomment to format also so the tailwind classes
  # doesn't format on save for some reason
  # plugins: [TailwindFormatter.MultiFormatter],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}"]
]
