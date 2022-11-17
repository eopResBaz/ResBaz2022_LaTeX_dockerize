Retrieve docker image:

- docker pull ghcr.io/eirianop/dockerresbaz2022:latest

Paste helper function in a bash shell (or add to your `.bashrc` or `.bash_profile` (Mac)):

- Linux and Mac:
    - `function create() { docker run --rm -v $(pwd):/results notebook2022:latest "$@"; }`
- Windows (GitBash):
    - `function create() { MSYS_NO_PATHCONV=1 docker run --rm -v $(pwd):/results notebook2022:latest "$@"; }`

Compiling `cheatsheet.tex` to PDF (this document):

- `create cheatsheet`

Compiling `document.tex` to PDF:

- `create pdf`

Compiling `document.tex` to .docx:

- `create word`

Compiling a single chapter:

- `create PAGE=pagename page`
- example:
- `create PAGE=00_timelinetemplate page`
- Hint:
    - `page` must be included with `\subfile` in `document.tex` or else this won't work

Create a new chapter for weekly journal entries

- `create timetracking`

Compile weekly logs

- `create weekly`

Compile logs for a single week

- `create PAGE=page week`
- example:
- `create PAGE=2022-06-06 week`

Create a template for meeting minutes

- `create meeting`

Compile all meeting minutes 

- `create minutes`

Compile a single meeting minute

- `create PAGE=page minute`
- example:
- `create PAGE=00_example minute`

Compile notes about references

- `create ref`

Compiling a presentation

- `create PAGE=page deck`
- example:
- `create PAGE=00_beamer_example deck`

Cleaning up:

- `create clean`

Cleaning up, and deleting PDFs:

- `create superclean`

Hints:

- Please don't modify templates. Some of them are used to auto-generate pages for you.
- Markdown will be converted to \LaTeX{} automatically
- Don't be afraid to play with the Makefile and create your own rules
- Try a `create clean` if a PDF should be generated but is failing. If it still fails, keep debugging.
- If you want to include a markdown file (e.g. using the `\subfile` command), use the `.tex` extension
    - example: file is named `my_note.md`
    - import like: `\subfile{my_note.tex}`