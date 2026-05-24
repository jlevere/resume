// Identity fields (title/email/phone/links) are passed at build time via
// `--input key=value` so they don't live in source control.

#let coalesce(value, fallback) = if value != none { value } else { fallback }

#let read-input(key) = {
  let v = sys.inputs.at(key, default: none)
  if v == none or v == "" { none } else { v }
}

#let header(title, contact) = align(center)[
  #text(weight: 700, size: 1.75em, title)
  #v(0.5em)
  #if contact.len() > 0 [#contact.join(" | ")]
  #v(1em)
]

#let entry(org: none, title: none, location: none, date: none, body) = block(
  spacing: 1em,
)[
  #grid(
    columns: (1fr, auto),
    row-gutter: 0.1em,
    inset: (top: 0.3em),
    text(weight: "bold", org), align(right, date),
    (title, location).filter(v => v != none).join(" | "), none,
  )
  #pad(left: 0.5em, body)
]

#let education(school: none, degree: none, date: none, details: none) = block(
  spacing: 0.7em,
)[
  #grid(
    columns: (1fr, auto),
    row-gutter: 0.6em,
    text(weight: "bold", school), align(right, date),
    text(style: "italic", degree), details,
  )
]

#let skills(categories) = block[
  #for (cat, items) in categories.pairs() [
    - #text(weight: "bold", cat + ": ") #items
  ]
]

#let title = read-input("title")
#let author = coalesce(read-input("author"), title)
#let commit = read-input("commit")
#let repo = read-input("repo")
#let contact = (
  read-input("phone"),
  read-input("email"),
  read-input("links"),
).filter(v => v != none)

#let build-description = if commit != none and repo != none {
  "Built from " + repo + " at commit " + commit + "."
} else { none }

#set document(
  title: coalesce(title, "Resume"),
  author: coalesce(author, ""),
  description: build-description,
  keywords: ("resume", "cv"),
)
#set page(margin: 2.5em)
#set text(size: 11pt, lang: "en")
#set par(justify: true, leading: 0.55em)
#set list(marker: [•], indent: 0pt, body-indent: 0.5em)

#show heading.where(level: 2): it => block(below: 0.5em)[
  #text(weight: 700, it.body)
  #line(length: 100%, stroke: 0.7pt)
]
#show link: it => underline(it, offset: 2pt)

#header(coalesce(title, "Your Name"), contact)

== Education

#education(
  school: "The Ohio State University",
  degree: "Bachelor of Arts in Computer and Information Science",
  date: "2020 - 2025",
)

== Experience

#entry(
  org: "IBM X-Force Red",
  title: "Penetration Testing Consultant",
  location: "Austin, Texas",
  date: "July 2025 - Present",
)[
  - Perform network and Active Directory penetration tests for enterprise clients.
  - Contribute to team engagements including source code reviews, image assessments, and web application testing.
]

#entry(
  org: "IBM X-Force Red",
  title: "Penetration Testing Intern",
  location: "Austin, Texas",
  date: "Summers 2023, 2024",
)[
  - Co-authored #link("https://github.com/logangoins/soapy", "SOAPy"), a stealthy Active Directory enumeration tool using ADWS over a SOCKS5 proxy; reverse-engineered and reimplemented proprietary Microsoft .NET protocols in Python. Companion research #link("https://www.ibm.com/think/x-force/stealthy-enumeration-of-active-directory-environments-through-adws", "published by IBM X-Force Red").
  - Co-developed a proof-of-concept C2 system using ETW for opportunistic Windows traffic capture without direct socket use; presented to IBM executives.
]

#entry(
  org: "OSU Cyber Security Club",
  title: "Member; Vice President 2023 - 2024",
  location: "Columbus, Ohio",
  date: "2020 - 2025",
)[
  - 1st place, RIT ISTS 2022 attack-defense competition; competed 2022 - 2024.
  - Helped run BuckeyeCTF, the university CTF hosting thousands of competitors each year.
  - At the Cyber Truck Challenge 2022, mapped and attacked heavy-truck ECUs and cyber-physical systems; presented findings to OEMs.
  - Worked with the Truck Cybersecurity Research Group on Engine Control Unit attack methodologies; designed Python networking for J1939 intelligent fuzzers and the J1939 Transport Protocol.
]

== Projects

- *#link("https://github.com/jLevere/azvpn", "azvpn")* _(Rust)_, a cross-platform Azure Virtual WAN and VPN Gateway client with AAD authentication, headless daemon, and native packaging. Fixes a long-standing macOS split-DNS bug missing from Microsoft's official client.
- *#link("https://github.com/jLevere/elfpreview", "elfpreview")* _(Rust + WebAssembly, TypeScript)_, a VS Code extension for inspecting ELF binaries; libgoblin compiled to WASM with WIT-typed bindings, Svelte 5 UI.
- *#link("https://github.com/jLevere/obsidian-mcp-plugin", "obsidian-mcp-plugin")* _(TypeScript)_, an Obsidian plugin embedding a Model Context Protocol server with selectable tools and optional bearer-token authentication.

== Skills

#skills((
  "Languages": "Rust, Python, Go, TypeScript, C, Zig",
  "Security": "Active Directory, BloodHound, Impacket, Burp Suite, Ghidra, Wireshark",
  "Infrastructure": "Nix, Terraform, AWS, Azure",
))

== Honors

#block(spacing: 0.7em)[
  *US National Team*, Target Pistol Shooting (2016 - 2024) \
  #link("https://en.wikipedia.org/wiki/Jack_Leverett_III", "2020 Tokyo Olympian"), Rapid Fire Pistol. Four-time All-American (2021 - 2024), OSU Scholar Athlete.
]
