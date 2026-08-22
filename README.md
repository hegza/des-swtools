# COMP.CE.340 Software Tools installation manual + container

## Getting started with the manual

```sh
# Fetch min-manual
git submodule update --init

# Render the document in PDF
typst c manual.typ
```

## Autoformat using typstyle

```sh
# Install typstyle
cargo install typstyle --locked

# Format
typstyle -i manual.typ
```
