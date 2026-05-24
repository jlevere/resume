/// Resume template for a single-page, ATS-friendly resume.
///
/// Parameters can be passed via `resume.with(...)` or `typst compile --input key=value`.
/// Fields left unset are omitted from the contact line rather than rendering
/// placeholders.
///
/// ```typ
/// #show: resume.with(
///   title: "Jane Doe",
///   email: "jane.doe@example.com",
///   phone: "(123) 456-7890",
///   links: "linkedin.com/in/janedoe, github.com/janedoe",
/// )
/// ```
/// -> content
#let resume(
  /// Name displayed at the top of the resume.
  /// -> string
  title: none,
  /// PDF document author metadata. Falls back to `title` when unset.
  /// -> string
  author: none,
  /// Contact email.
  /// -> string
  email: none,
  /// Contact phone.
  /// -> string
  phone: none,
  /// Professional links (LinkedIn, GitHub, etc.).
  /// -> string
  links: none,
  /// Resume body.
  /// -> content
  body,
) = {
  let resolve(key, given) = {
    if given != none { given } else { sys.inputs.at(key, default: none) }
  }

  let title = resolve("title", title)
  let author = resolve("author", author)
  let author = if author != none { author } else { title }
  let email = resolve("email", email)
  let phone = resolve("phone", phone)
  let links = resolve("links", links)

  set document(
    title: if title != none { title } else { "Resume" },
    author: if author != none { author } else { "" },
    keywords: ("resume", "cv"),
    date: datetime.today(),
  )

  set page(margin: 2.5em)
  set text(size: 11pt, lang: "en")
  set par(justify: true, leading: 0.55em, spacing: 1em)
  set list(marker: [•], indent: 0pt, body-indent: 0.5em)

  show heading: it => {
    set text(weight: 700)
    set block(below: 0.5em)
    it
  }

  show link: it => underline(it, offset: 2pt)

  let contact = (phone, email, links).filter(v => v != none and v != "")

  align(center)[
    #text(weight: 700, size: 1.75em, title)
    #v(0.5em)
    #if contact.len() > 0 [
      #contact.join(" | ")
    ]
    #v(1em)
  ]

  body
}

/// Section heading with a horizontal divider.
///
/// ```example
/// #section("Experience")
/// ```
/// -> content
#let section(
  /// Section title.
  /// -> string
  title,
) = {
  heading(level: 2, title)
  line(length: 100%, stroke: 0.7pt)
}

/// Resume entry for experience, projects, or other achievements.
///
/// ```example
/// #entry(
///   organization: "IBM X-Force Red",
///   title: "Pentest Intern",
///   location: "Austin, Texas",
///   date: "May-August 2023",
///   bullets: (
///     [Worked in team to develop a C2 system],
///     [Shadowed pentesters],
///   ),
/// )
/// ```
/// -> content
#let entry(
  /// Company or organization.
  /// -> string
  organization: none,
  /// Position or job title.
  /// -> string
  title: none,
  /// Geographic location.
  /// -> string
  location: none,
  /// Time period (e.g., "May 2022 - Present").
  /// -> string
  date: none,
  /// Bullet point descriptions.
  /// -> array
  bullets: (),
) = block(spacing: 1em)[
  #grid(
    columns: (1fr, auto),
    row-gutter: 0.1em,
    inset: (top: 0.3em),
    text(weight: "bold", organization), align(right, date),
    (title, location).join(" | "), none,
  )
  #if bullets.len() > 0 {
    pad(left: 0.5em, list(..bullets))
  }
]

/// Skills section with categorized lists.
///
/// ```example
/// #skills-section((
///   "Programming Languages": "Python, Golang, Zig, C, Terraform",
///   "Tools & Frameworks": "Ghidra, Pwntools, AWS, WireShark",
/// ))
/// ```
/// -> content
#let skills-section(
  /// Mapping of category name to comma-separated skills.
  /// -> dictionary
  categories,
) = block[
  #for (category, skills) in categories.pairs() [
    - #text(weight: "bold", category + ": ") #skills
  ]
]

/// Education entry with institution, degree, and details.
///
/// ```example
/// #education(
///   institution: "The Ohio State University",
///   degree: "B.A. Computer and Information Science",
///   date: "2020 - 2025",
///   details: [GPA: 3.9],
/// )
/// ```
/// -> content
#let education(
  /// School or university name.
  /// -> string
  institution: none,
  /// Degree title or program of study.
  /// -> string
  degree: none,
  /// Time period (e.g., "2020 - 2024").
  /// -> string
  date: none,
  /// Optional additional info (e.g., GPA, minors, honors).
  /// -> content
  details: none,
) = block(spacing: 0.7em)[
  #grid(
    columns: (1fr, auto),
    row-gutter: 0.6em,
    text(weight: "bold", institution), align(right, date),
    text(style: "italic", degree), details,
  )
]
