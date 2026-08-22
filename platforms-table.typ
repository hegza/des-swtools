#import "tuni-style.typ": *

#let support = (
  // Officially supported
  yes: [#emoji.checkmark.box Supported],
  deprecated: [#emoji.warning Deprecated],
  // Don't expect it to work
  no: [#emoji.warning Not supported],
  broken: [#emoji.crossmark Broken],
)
#let platforms = (
  ubuntu-2404: (
    name: "Ubuntu",
    version: "24.04",
    support: support.yes,
    tested: datetime(year: 2025, month: 12, day: 1),
    comment: [Official target. Class Virtual Machines.],
  ),
  opensuse-tw-20260819: (
    name: [openSUSE],
    version: [Tumbleweed (20260819)],
    support: support.no,
    tested: datetime(year: 2026, month: 8, day: 22),
    comment: [Heksa's daily driver. Not officially supported, but you can always ask.],
  ),
  wsl: (
    name: [WSL#footnote[Windows Subsystem for Linux]],
    version: none,
    support: support.no,
    tested: datetime(year: 2025, month: 12, day: 1),
    comment: [Has been shown to work, but requires extra configuration for USB forwarding.],
  ),
  windows: (
    name: [Windows],
    version: [11 (26H1)],
    support: support.no,
    tested: datetime(year: 2026, month: 02, day: 1),
    comment: [Has been shown to work. Requires a driver to be downgraded.],
  ),
)

#{
  set text(size: tuni-font-size-code)
  table(
    columns: (auto, 7.5em, auto, auto, 1fr),
    align: (
      horizon + center,
      horizon + center,
      horizon + center,
      horizon + center,
      horizon + left,
    ),
    inset: 0.5em,
    table.header(
      [*OS*], [*Version /\ release*], [*Support*], [*Last tested*], [*Comment*]
    ),
    ..platforms
      .values()
      .map(p => {
        let comment = p.values().at(4, default: none)
        let (name, version, support, tested) = p
        (
          name,
          if version != none { version } else [],
          support,
          if tested != none { tested.display() },
          if comment != none {
            set par(justify: false)
            set text(hyphenate: true)
            comment
          } else [],
        )
      })
      .join(),
  )
}
