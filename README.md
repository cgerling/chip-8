# Chip-8

<!-- MDOC !-->

A Chip-8 interpreter.

Created by Joseph Weisbecker in the mid-1970s, Chip-8 is a programming language
composed of hexadecimal instructions and are executed on the fly by a virtual
machine. The language was created to make it easier to develop video games for
the [COSMAC VIP](https://en.wikipedia.org/wiki/COSMAC_VIP) microcomputer.

After becoming popular because of its simplicity, people started to implement
interpreter versions for other platforms but, because the language did not have
a formal specification, many of these versions some instruction had some
deviations on their behavior compared to the original COSMAC VIP version.

This project follows the [Cowgod's Chip-8 Technical Reference v1.0](http://devernay.free.fr/hacks/chip8/C8TECH10.HTM)
specification and partially replicates the specification on its own
documentation, being able to act as standalone documentation if needed.

## Usage

To run programs, you must initialize an interpreter instance
through `Chip8.initialize/1`:

```elixir
Chip8.initialize(program_data)
```

The returned interpreter instance holds all the required states for the program's
execution at a given point in time. Since the instance is just a pure data
structure, your application will be the one responsible to manage everything,
from user interaction to managing cycles and their relation with timers.

See all `Chip8` functions for more information about each operation.

