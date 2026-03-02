# Building Standalone Binaries

> **Do not use `mix escript.build` for distribution.** Escript archives cannot
> bundle native extensions (exqlite NIF) or priv directories (tzdata). The
> escript entry point will detect this and exit with an error. Use `mix release`
> or Burrito instead. The escript config in `mix.exs` exists only for quick
> development iteration. See [#39](https://github.com/bleuropa/loomkin/issues/39)
> and [#43](https://github.com/bleuropa/loomkin/issues/43).

Loomkin can be packaged as a single self-contained binary using [Burrito](https://github.com/burrito-elixir/burrito). The binary bundles the BEAM runtime, so users don't need Elixir or Erlang installed.

## Quick Build (current platform)

```bash
# Build a release binary for your current OS/arch
MIX_ENV=prod mix release loomkin

# The binary will be in burrito_out/
./burrito_out/loomkin_macos_aarch64
```

## Cross-Platform Builds

```bash
# Build for all configured targets
MIX_ENV=prod mix release loomkin

# Targets (configured in mix.exs):
#   macos_aarch64  — Apple Silicon Mac
#   macos_x86_64   — Intel Mac
#   linux_x86_64   — Linux x86_64
#   linux_aarch64  — Linux ARM64
```

## Standard Mix Release (without Burrito)

If you prefer a standard OTP release without Burrito wrapping:

```bash
# Comment out the Burrito steps in mix.exs releases config, then:
MIX_ENV=prod mix release loomkin

# Run the release
_build/prod/rel/loomkin/bin/loom start

# Or run migrations manually
_build/prod/rel/loomkin/bin/loom eval "Loomkin.Release.migrate()"
```

## Release Behavior

- Database is stored at `~/.loomkin/loomkin.db` (override with `LOOMKIN_DB_PATH`)
- Migrations run automatically on startup
- Web UI starts on port 4200 (override with `PORT`)
- A deterministic secret key base is derived from your home directory (override with `SECRET_KEY_BASE`)

## Cost Dashboard

Visit `/dashboard` in the web UI to see real-time telemetry:

- Per-session token usage and cost tracking
- Model usage breakdown
- Tool execution frequency and performance
