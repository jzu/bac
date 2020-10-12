# bac - Basic Avalanche CLI

`bac` acts as a Unix CLI wrapper around the [Avalanche JSON API](https://docs.avax.network/v1.0/en/api/intro-apis/), making it easier to call simple methods.

`-f` formats the output using [jq](https://stedolan.github.io/jq/).
<br>
`-n` does nothing but display the Curl command.
<br>
`-h` gives help.
<br>
Arguments are key:value pairs (quotes unnecessary).
<br>
Endpoint is inferred from the service part of the method.

## Usage example

    bac -f avm.getBalance address:X-avax1tmnpf87ph0pap4p507zfr0zesafnj5qh0sdkjc assetID:AVAX

Providing an incomplete method name (i.e. without . or &lowbar;) has it grepped 
in `[/usr/local/etc/]bac.sigs` and matching method signatures are displayed.
<br>
These have been extracted and processed from the 
[Avalanche Postman Collection](https://github.com/ava-labs/avalanche-postman-collection)
with the `gensigs.pl` script.

### Advanced Usage


#### Objects and Arrays

First attempt was a fail. Working on a much simpler solution.

#### Password Management

If you don't like entering your password on the command line (and in
`.bash_history`), use the BACPWD macro. The script looks up the username you
provided in the `~/.bacpwd` file, fetches the password part, e.g. `S|kr33t`,
and replaces the macro by `"password":"S|kr33t"`. This file must belong to your
Unix account and be accessible read-only by you excluding anyone else, meaning
400. Each line is an account, of the form `username password` separated by
spaces. By the way, it also fixes the issue of having special characters in the
password.

Example:

    bac -f some.method username:foo BACPWD

## Installation

The script works in any directory by calling `./bac …` , but you can install it system-wide:

    sudo install -m 755 bac /usr/local/bin
    sudo install -m 644 bac.sigs /usr/local/etc

There are no prerequisites if you only need raw outputs. The `-f` (format) option wants `jq`, which you can install using `apt install jq`.

## Limitations

All services are (supposed to be) supported, except

- the C-chain (not fully tested, some methods do work)
- objects and arrays are not implemented yet, coming Real Soon Now™
- there's always one more bug (Lubarsky's Law of Cybernetic Entomology)

… for now. Currently trying to overcome these issues. A real parser would be
fine… in another language.

Avalanche Postman Collection is a secondary source for signatures but there's
nowhere in the avalanchego repo where you can find prototypes for these
methods, so signatures may differ from the documentation - that's life. Oh and
it needs Perl. Sorry. Anyway the generated file is included here.
