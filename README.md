# bac - Basic Avalanche CLI

`bac` acts as a Unix CLI wrapper around the [Avalanche JSON API](https://docs.avax.network/v1.0/en/api/intro-apis/), making it easier to issue simple calls.

`-f` formats the output using [jq](https://stedolan.github.io/jq/).
<br>
Arguments are key:value pairs (quotes unnecessary).
<br>
Endpoint is inferred from the service part of the method.

## Usage example

    bac -f avm.getBalance address:X-avax1tmnpf87ph0pap4p507zfr0zesafnj5qh0sdkjc assetID:AVAX

`bash -x bac …` will show the full curl command.

Providing an incomplete method name (i.e. without . or &lowbar;) has it grepped 
in `[/usr/local/etc/]bac.sigs` and matching method signatures are displayed.
<br>
These have been extracted and processed from the Avalanche Documentation.
There must be a better way to do it in order to keep up with changes.

## Installation

The script works in any directory by calling `./bac …` , but you can install it system-wide:

    sudo install -m 755 bac /usr/local/bin
    sudo install -m 644 bac.sigs /usr/local/etc

There are no prerequisites if you only need raw outputs. The `-f` (format) option wants `jq`, which you can install using `apt install jq`.

## Limitations

All services are (supposed to be) supported, except

- the C-chain (non-standard method names)
- methods needing complex data structures, e.g. `avm.createNFTAsset`
- when passwords contain ":"

… for now. Currently trying to overcome these issues.

