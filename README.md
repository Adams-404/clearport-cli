# Clearport CLI

A small, local-first CLI for running GGUF models on Android through Termux and llama.cpp. Start a local model server, chat from your terminal, inspect loaded models, and manage the server without opening the Clearport Android app.

The Android app is optional. Both the app and CLI can connect to the same local API.

## Install on Termux

Run this single command inside Termux:

```bash
curl -fsSL https://raw.githubusercontent.com/Adams-404/clearport-cli/main/install.sh | bash
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

## Commands

| Command | Description |
| --- | --- |
| `clearport start` | Start the managed llama.cpp server |
| `clearport chat` | Chat with the running model in Termux |
| `clearport status` | Check server process and API health |
| `clearport models` | List models exposed by the API |
| `clearport local-models` | List local GGUF files |
| `clearport use <file>` | Choose the GGUF model to load |
| `clearport logs` | Follow the server log |
| `clearport stop` | Stop the managed server |
| `clearport restart` | Restart with the current configuration |
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
