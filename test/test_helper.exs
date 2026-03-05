ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Loomkin.Repo, :manual)

# Skip LLM-dependent tests in CI (no API keys available)
if System.get_env("CI"), do: ExUnit.configure(exclude: [:llm_dependent])

# Mox mock definitions for channel adapter tests
Mox.defmock(Loomkin.MockAdapter, for: Loomkin.Channels.Adapter)
Mox.defmock(Loomkin.MockTelegex, for: Loomkin.Channels.TelegexBehaviour)
Mox.defmock(Loomkin.MockNostrumApi, for: Loomkin.Channels.NostrumApiBehaviour)
