defmodule Loomkin.Channels.Supervisor do
  @moduledoc """
  Supervises channel adapter processes and the bridge supervisor.

  Only starts channel-specific children (Telegram webhook, Discord consumer)
  when their respective configs are enabled.
  """

  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    children =
      [
        Loomkin.Channels.AuditLog,
        Loomkin.Channels.BridgeSupervisor,
        {Task.Supervisor, name: Loomkin.Channels.WebhookTaskSupervisor}
      ] ++ telegram_children() ++ discord_children()

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp telegram_children do
    config = Loomkin.Config.get(:channels, :telegram) || %{}

    if config[:enabled] do
      # Webhook is a Plug — started as part of the Phoenix endpoint router,
      # not as a standalone child. Nothing to add here for Telegram beyond
      # the bridge supervisor which is already started above.
      []
    else
      []
    end
  end

  defp discord_children do
    config = Loomkin.Config.get(:channels, :discord) || %{}

    if config[:enabled] do
      [Loomkin.Channels.Discord.Consumer]
    else
      []
    end
  end
end
