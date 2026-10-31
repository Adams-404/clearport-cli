# Clearport CLI

A small, local-first CLI for running GGUF models on Android through Termux and llama.cpp. Start a local model server, chat from your terminal, inspect loaded models, and manage the server without opening the Clearport Android app.

The Android app is optional. Both the app and CLI can connect to the same local API.

## Install on Termux

Run this single command inside Termux:

```bash
pkg install -y curl && curl -fsSL https://raw.githubusercontent.com/Adams-404/clearport-cli/main/install.sh | bash
```

The installer installs the required Termux packages and places the CLI in `$PREFIX/bin`. It does not download model weights.

## Get started

Place one or more `.gguf` files in `~/models`. Then:

```bash
clearport local-models
clearport use ~/models/your-model.gguf
clearport start
clearport chat
```

If there is exactly one GGUF file in `~/models`, the first `clearport start` selects it automatically. If there are multiple files, select one with `clearport use`.

## Get a model (Gemma)

No weights ship with Clearport. If you do not have a GGUF yet, the CLI can fetch a
verified Gemma model for you:

```bash
clearport pull gemma        # Gemma 3 1B, Q4_K_M — 806 MB, the balanced default
clearport pull gemma-tiny   # Gemma 3 270M, Q8_0 — 292 MB, fastest and smallest
```

Downloads land in `~/models`, resume if the connection drops, and are checked against
the published byte size and SHA-256 before use. If no model is configured yet, the
pulled model is selected automatically.

Both are open-weight models under the Gemma Terms of Use. Rough RAM: about 1.2 GB for
1B and 500 MB for 270M. On a phone with 4 GB or less, start with `gemma-tiny`.

## Haunt

```bash
clearport haunt        # the last 6 commands
clearport haunt 10     # the last 10
```

`haunt` reads your shell history, sends the last few commands to the loaded model,
and prints a short comment back. It never leaves the device, never uploads history,
and never sends anything but the commands you already typed in this shell.

To see what would be sent without calling the model:

```bash
clearport haunt --dry-run
```

The command is a small joke with a point: the model lives in the same phone as your
shell, so it can read what you just did. That is either charming or unsettling,
depending on how your day went.

## Commands

| Command | Description |
| --- | --- |
| `clearport start` | Start the managed llama.cpp server |
| `clearport chat` | Chat with the running model in Termux |
| `clearport haunt [n]` | Let the model read your last `n` shell commands and comment on them |
| `clearport status` | Check server process and API health |
| `clearport models` | List models exposed by the API |
| `clearport local-models` | List local GGUF files |
| `clearport use <file>` | Choose the GGUF model to load |
| `clearport pull <model>` | Download a verified Gemma GGUF into `~/models` |
| `clearport logs` | Follow the server log |
| `clearport stop` | Stop the managed server |
| `clearport restart` | Restart with the current configuration |
| `clearport update` | Update the CLI scripts to latest from GitHub |
| `clearport config` | Edit server configuration |
| `clearport version` | Show CLI version |

During chat, enter `/clear` to clear conversation context or `/exit` to quit. Chat requests are non-streaming in this initial release, so a response appears when generation completes.

## Defaults

- Server: `llama-server` from the Termux `llama-cpp` package
- API: `http://127.0.0.1:8080/v1`
- Bind address: loopback only (`127.0.0.1`)
- Model directory: `~/models`
- Configuration: `~/.config/clearport/server.conf`
- PID and logs: `~/.local/state/clearport/`

Example configuration:

```sh
MODEL_PATH="$HOME/models/qwen2.5-1.5b-instruct-q4_k_m.gguf"
LLAMA_SERVER_BIN="llama-server"
HOST="127.0.0.1"
PORT="8080"
EXTRA_ARGS="-c 2048 -t 4"
```

Edit it with `clearport config`. Keep the host set to `127.0.0.1`: the CLI intentionally avoids exposing an unauthenticated model API to other devices on your network.

## Use with the Clearport Android app

Start the server in Termux, then set the Android app's server URL to:

```text
http://127.0.0.1:8080/v1
```

You can use the terminal chat or the Android interface. Avoid running multiple large generations simultaneously on a phone with limited memory.

## Keep Termux running in the background

Clearport requests a Termux wake lock when starting the server. This does not override every Android manufacturer's background restrictions.

On affected itel devices, a separate setting can suspend Termux even when normal battery settings appear unrestricted:

**Special Functions → AI → Intelligent Management → Foreground Intelligence**

Disable Foreground Intelligence if it is interfering with a long-running local server. Keep Battery Saver off during long sessions as well.

## Requirements and notes

- Android phone with Termux.
- A Termux repository that provides the `llama-cpp` package.
- A compatible GGUF model downloaded separately.
- The installer installs `bash`, `curl`, `jq`, `procps`, `coreutils`, `termux-tools`, `llama-cpp`, and `nano`.
- Model files can be large. The installer never downloads one automatically.
- `clearport stop` only stops a server started and tracked by Clearport. If another process already owns port 8080, stop or reconfigure that process yourself.
- The CLI uses the OpenAI-compatible `/v1/chat/completions` and `/v1/models` endpoints.

## Uninstall

```bash
rm -f "$PREFIX/bin/clearport" "$PREFIX/bin/clearport-server"
```

This leaves your model files, configuration, and logs untouched.

## License

MIT. See [LICENSE](LICENSE).
