# bac - Basic Avalanche CLI

`bac` acts as a Unix command-line interface wrapper around the 
[Avalanche JSON API](https://docs.avax.network/build/avalanchego-apis), 
making it easier to call simple methods.

`-f` formats the output using [jq](https://stedolan.github.io/jq/).
<br>
`-n` does nothing but display the Curl command.
<br>
`-h` gives help.
<br>
Arguments are key:value pairs (quotes unnecessary), pairs being separated by spaces.
<br>
Endpoint is inferred from the service part of the method.

## Usage example

    bac -f avm.getBalance address:X-avax1tmnpf87ph0pap4p507zfr0zesafnj5qh0sdkjc assetID:AVAX

Providing an incomplete method name (i.e. without `.` or `_`) has it grepped in
`[/usr/local/etc/]bac.sigs` and matching method signatures are displayed. The
file has been generated  by scraping the 
[documentation pages](https://docs.avax.network/apis/avalanchego/apis), some 
basic text processing, and manual editing. Methods suffixed with `!` are 
deprecated. Arguments suffixed with `°` are optional. Example:

    $ bac blockchain
    platform.createBlockchain! : subnetID, vmID, name, genesisData, encoding°, from[]°, changeAddr°, username, password
    platform.getBlockchains!
    platform.getBlockchainStatus : blockchainID

### Advanced Usage

Ok, this is the _Basic_ Avalanche CLI, but you can do whatever you
want, even with the `avax` API now (beta). You can also use
[avalanche-cli](https://www.npmjs.com/package/avalanche-cli).
You may find it better suited for complex requests.

#### Objects and Arrays

You write objects pretty much as you would in JSON, only simpler:

    key1:{key2a:value2a key2b:{key3a:value3a key3b:value3b}}

Same for arrays:

    key1:[value1a value1b]

## Installation

The script works in any directory by calling `./bac …` provided it has execution rights
(`chmod 755 bac` if it's not the case), but you can install it system-wide:

    sudo install -m 755 bac /usr/local/bin
    sudo install -m 644 bac.sigs /usr/local/etc

There are no prerequisites if you only need raw outputs. The `-f` (format)
option wants `jq`, which you can install using `apt install jq`.

## Limitations

All services are (supposed to be) supported, except

- the C-chain (not fully tested, some methods do work)
- there's always one more bug (Lubarsky's Law of Cybernetic Entomology)

… for now. 

`gensigs.pl` never really worked and has been discarded.
<br>
The -n option forgets the simple quotes.
<br>
The EVM API seems incomplete. 
<br>
The `avax` RPC endpoints are unmanageable in an automatic way: see 
[https://docs.avax.network/apis/avalanchego/apis/c-chain](https://docs.avax.network/apis/avalanchego/apis/c-chain).
<br>
You shouldn't try to understand the `PARAMS` sed regexps, unless you're into
[Malbolge](https://en.wikipedia.org/wiki/Malbolge).
<br> 
_Some people, when confronted with a problem, think "I know, I'll use regular
expressions." Now they have two problems._ (J. Zawinski)

