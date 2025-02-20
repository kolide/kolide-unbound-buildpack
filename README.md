# kolide-unbound-buildpack

This buildpack configures unbound to run as a daemon on Heroku.

It expects that the [apt](https://github.com/heroku/heroku-buildpack-apt) buildpack has already run,
with an Aptfile with the following contents:

```
unbound
libpython3.10
```

It also expects a Heroku config var `UNBOUND_JSON` to be set, with valid JSON in the following format:

```json
{
    "forward": [
        {
            "zone": "<zone-here>",
            "addrs": [
                "<ip-addr-here>"
            ]
        }
    ]
}
```

For your Heroku app to use unbound, you must enable setting an extra DNS resolver for your app, and then add 127.0.0.1 as your DNS resolver.
This can be done by e.g. running:

```
heroku labs:enable spaces-extra-resolver -a [APP NAME]
heroku config:set HEROKU_EXTRA_RESOLVER=127.0.0.1 -a [APP NAME]`
```
