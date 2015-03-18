# offyougo

Simple, interactive command-line utility for offloading camera media using rsync.
Currently, this script only supports offloading RED media. Generic camera support
is planned.

While it is very easy to use, this script is only for people with a basic understanding
of command line environments.

## Features

* Safe and secury copying using rsync
* Clear, colorful indication of success and error
* Ability to unmount drives after copying
* Auto-detection of RED media

## Installation

The installation happens on the command line via the ``gem`` command:

```
# Install newest version
gem install offyougo

# Install specific version
gem install offyougo -v 0.0.1

# Run specific version
offyougo _0.0.1_
```

## Development state

This app is, to be short, quick and dirty as it was made out of an urgent need
for a nice, easy-to-use and safe camera offloading script. However, it has been
proven by a real production and is therefore ready for production use basically.

I can't stress enough that this comes WITHOUT ANY WARRANTY (see license). Please
test thoroughly before using it on a real production. Also, always have a quick
look at the rsync command that is printed out before confirming it.