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
