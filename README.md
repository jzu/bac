# bac - Basic Avalanche CLI

`bac` acts as a Unix CLI wrapper around the [Avalanche JSON API](https://docs.avax.network/v1.0/en/api/intro-apis/), making it easier to call simple methods.

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

Providing an incomplete method name (i.e. without . or &lowbar;) has it grepped
in `[/usr/local/etc/]bac.sigs` and matching method signatures are displayed. The
file is generated through `gensigs.pl`, which needs Perl and w3m, by scraping the
[documentation pages](https://docs.avax.network/v1.0/en/api/intro-apis/). No EVM yet.

### Advanced Usage

Ok, this is the _Basic_ Avalanche CLI, but you can do whatever you
want&mdash;theoretically. You can also use
[avalanche-cli](https://github.com/ava-labs/avalanche-cli), although it is
archived now. You may find it better suited for complex requests.

#### Objects and Arrays

You write objects pretty much as you would in JSON, only simpler:

    key1:{key2a:value2a key2b:{key3a:value3a key3b:value3b}}

Same for arrays:

    key1:[value1a value1b]

#### Password Management

If you don't like entering your password on the command line (and in
`.bash_history`), use the BACPWD macro. The script looks up the username you
provided in the `~/.bacpwd` file, fetches the password part, e.g. `S|kr33t`,
and replaces the macro by `"password":"S|kr33t"`. This file must belong to your
Unix account and be accessible read-only by you excluding anyone else, meaning
`-r--------` (`chmod 400 ~/.bacpwd`). Each line is an account, of the form
`username password` separated by spaces. By the way, it also fixes the issue of
having special characters in the password.

Example:

    bac -f some.method username:foo BACPWD

## Installation

The script works in any directory by calling `./bac …` , but you can install it
system-wide:

    sudo install -m 755 bac /usr/local/bin
    sudo install -m 644 bac.sigs /usr/local/etc

There are no prerequisites if you only need raw outputs. The `-f` (format)
option wants `jq`, which you can install using `apt install jq`.

## Limitations

All services are (supposed to be) supported, except

- the C-chain (not fully tested, some methods do work)
- there's always one more bug (Lubarsky's Law of Cybernetic Entomology)

… for now. 

You shouldn't try to understand the `PARAMS` sed regexps, unless you're into
[Malbolge](https://en.wikipedia.org/wiki/Malbolge).
<br> 
_Some people, when confronted with a problem, think "I know, I'll use regular
expressions." Now they have two problems._ (J. Zawinski)

