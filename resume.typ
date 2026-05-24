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
#let contact = (
  read-input("phone"),
  read-input("email"),
  read-input("links"),
).filter(v => v != none)

#set document(
  title: coalesce(title, "Resume"),
  author: coalesce(author, ""),
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
  title: "Pentest Intern",
  location: "Austin, Texas",
  date: "May-August 2024",
)[
  - Engineered a stealthy LDAP tool in python, #link("https://github.com/logangoins/soapy", "soapy"), building eight communication layers and authentication mechanisms from the ground up. Developed a stand alone tool compatible with the well known impacket tool set.
  - Worked with senior pentesters during live engagements to identify and exploit vulnerabilities.
]

#entry(
  org: "IBM X-Force Red",
  title: "Pentest Intern",
  location: "Austin, Texas",
  date: "May-August 2023",
)[
  - Worked in team to develop a C2 system using ETW for opportunistic traffic capture on Windows devices, enabling covert communication without direct socket use. Presented a proof of concept to IBM executives.
  - Shadowed experienced pentesters on app and internal network penetration tests, gaining valuable insights.
  - Completed series of expert-led, training programs focused on network penetration, web application security, cryptography, social engineering, and mobile application security.
]

#entry(
  org: "The Ohio State University Athletics Department",
  title: "IT Student Intern",
  location: "Columbus, Ohio",
  date: "May 2022 - August 2022",
)[
  - Developed processes to track and document vulnerability remediation across four thousand devices.
  - Worked with the myriad of tools used to secure and manage large enterprise environments including CrowdStrike, Qualys, and the SolarWinds suite.
]

== Extracurricular

#entry(
  org: "OSU Cyber Security Club",
  title: "Vice President / Member",
  location: "Columbus, Ohio",
  date: "August 2020 - Present",
)[
  - Member of the winning RIT ISTS 2022 team, an attack-defense cybersecurity competition. Competed in ISTS from 2022 to 2024.
  - Led meetings, managed AWS infrastructure using Terraform, and coordinated BuckeyeCTF, organizing participation for thousands annually.
  - Participated in the Cyber Truck Challenge 2022, working in a six-person team to map and attack heavy truck engine control units, communication networks, and cyber-physical systems. Presented findings and vulnerabilities to OEMs.
  - Collaborated with the Truck Cybersecurity Research Group to develop attack methodologies for Engine Control Units.
  - Designed Python network support for J1939 intelligent fuzzers and J1939 Transport Protocol.
]

#entry(
  org: "US National Team",
  title: "Athletics Experience, Target Pistol Shooting",
  location: "OSU Varsity Athlete",
  date: "August 2016 - 2024",
)[
  - 2020 Tokyo Olympian, Rapid Fire Pistol
  - Dedicated 20+ hours a week to training and practice while maintaining a full academic course load.
  - 2021, 2022, 2023, 2024 All-American, OSU Scholar Athlete.
  - 2018 CAT Games Mexico, 2018 South Korea World Championship team, 2019 Pan-American Games Lima.
]

== Skills

#skills((
  "Programming Languages": "Python, Golang, Zig, C, Terraform",
  "Tools & Frameworks": "Ghidra, Pwntools, AWS, WireShark",
))
