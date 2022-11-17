## Instructor set up

LaTeX Workshop

- enable autobuild on save in VS Code

---

# Quick Overview

## intro

- this is what we're going to do today
    - stop paying for free software
    - use git, have as many collaborators as you like
    - collaborate with Word users without becoming one
        - (show examples of PDFs I've made)
        - (show examples of word docs I've made)
    - why?
        - minimize time to get started
        - make lots of customizations
        - automate, automate, automate
- well known that if you're using LaTeX, a lot of people don't
- how do we work with people using word???
- this is a solution that we have that is easy to run, a good workflow pipeline, so that we can work with people in word

## Do a demo (instructor only, participants will need to do set-up first)

generate interest

- open file explorer in proper directory
- do a `create pdf`
- generate a single page
    - `create PAGE=2022-06-06 page`
    - `create PAGE=2022-06-06 page-word`
    - not exactly the same, but close enough for collaborators!

Today's session is all about getting started quick

- automate the boring stuff out of the way
- focus on your work

---

## Check if everyone has pre-reqs installed

You should have:

- VSCode
- GitHub account, OR
- docker 

How many people have docker installed?

- if more than a few, walk through 
- `docker pull ghcr.io/eirianop/dockerresbaz2022:latest`

Everyone else needs a GitHub account. 
- logged in?
- visit https://github.com/eirianop/ResBaz2022_LaTeX_dockerize
- fork the repo 

Please download VS Code if you have not 
- https://code.visualstudio.com/download
- if this isn’t possible for some reason, please follow along in GitHub 

If you are stuck, please ask for help in chat

- (give it a moment)

Move on to `getting started`, but go slowly, give enough time to catch up


---

# getting started

- Open docker desktop

## Setting up Repo


- navigate to https://github.com/eirianop/ResBaz2022_LaTeX_dockerize
    - click on `code`
    - copy **clone** URL (HTTPS)
- VS Code
    - clone https://github.com/eirianop/ResBaz2022_LaTeX_dockerize
- if participant doesn’t have got 
  - if they have docker, download zip
  - please install git, or worse case, follow along on GitHub
    

---

# VS Code tour


(show opening terminal, generating PDF and viewing it again)


VS Code is an *integrated development environment (IDE)*

- the environment where you will do your work (e.g. writing manuscript)
- you should pick an IDE that best fits your needs
- Don't be afraid to try out different IDEs later



## Overview

- from 
  - https://code.visualstudio.com/docs/getstarted/userinterface
- you can have any number of windows open
- you can open folders, rather than individual files
- this is similar to R Studio, where you can open a workspace
- **the best part** -- quickly pick up where you left off. If you quit
  VS Code or shut down your computer, when you open VS Code again, 
  it will re-open all the windows you had open, in the proper directories.
- this minimises time to get started, and helps you focus on your work

### The Activity Bar

- the vertical bar on the very left hand side of the screen
- lets you switch between side bar views and gives you additional context-specific 
  indicators
- you can click an icon on the activity bar to collapse it
  - This is great for reducing distractions in your work environment

### Side bar

Side Bar: Explorer

- this takes you to a file explorer view
- you can see the contents of the directory you are in
- if your directory is version controlled, the explorer will tell you
  which files have been modified, and which are untracked
- if you click on the explorer icon again, it will collapse, giving you
  a lower-distraction enviornment

Side Bar: Search

- you can search the contents of your working directory for text
- it also supports find and replace

Side Bar: Source control

- if you are using a source control management (SCM) tool, this view
  will show modifications since your last commit
- keep an eye on it as we code together later

Side Bar: Run and Debug

- this is for software development, out of scope


Side Bar: Extensions

- VS Code has an extension marketplace.
- There are some official extensions
- Developers can also publish extensions here

Extensions:

- clicking on the Extensions view will show you everything you have installed
- you can find new extensions by using the search bar in the 
  Extensions view
- We should install `LaTeX Workshop` written by **James Yu**
  - includes the PDF preview feature
  - ...and lots of other nice stuff, like \LaTeX{} tab completion
  - search for `LaTeX` and click install
  - you can also install `LaTeX Utilities`, but it's no longer actively
    maintained. It is an add-on for `LaTeX Workshop` that makes some 
    features a little nicer


### Editor

- The main area to edit your files
- you can open as many files as you like
- `open document.tex`
  - double click it
  - single click opens a *preview*
  - `DEMO` split view
- `minimap` is a high-level overview of the file you have open
  - useful for quick navigation

---

## Demo: compiling with LaTeX Workshop

Save `document.tex`

- (this may not even work if you haven't installed TeXLive or some other tool distribution)
- this is nice, it works like Overleaf
- ...with some trade-offs
  - show, in file explorer, that LaTeX workshop is dumping garbage into
    our working directory
  - we also miss out on opportunities to make our own customisations
    (which we will see shortly)
  - example: where's the compile to word option? (it's not there)
- `disable autobuild in Settings UI`
  - file -> preferences -> settings

---

### Integrated terminal

We need a new way to build our \LaTeX{} project, 
(like we did in the first demo)

Open integrated terminal 

- open/close it with ``Ctrl+` ``
  - or View -> Terminal
- we will be using this a lot, handy to remember the key combo
- the right hand side of the terminal pane tells you what shell you 
  are running. 
  - if you prefer bash, click the down arrow next to the + and
    open a bash terminal
- you can open multiple terminal windows and navigate between them

---

## Questions before moving on?

Ask me (almost) anything!

---

# Taking notes quickly

## With Markdown!

Scenario

- I am a first year PhD student and I want to take minutes for each meeting
  I have with my supervisor

Goals

- I want to take quick notes (no verbose \LaTeX{} syntax)
- I don't want to re-type everything later

Let's start by jotting down some notes

## Example 01 -- heading and lists

Create a new folder, `pages/resbaz`:

Create a new file, `pages/resbaz/ex01.md`:

```
# Example 1

Today I am learning how to use \LaTeX{} like a pro.
I have learned the following:

- setting up tools
- compiling to PDF
- compiling to word

I wish I could write \LaTeX{} without knowing \LaTeX{}
```

We've just created a markdown file
  - `show rendered preview in VS Code`
  - Markdown is a lightweight markup language for creating formatted text using a plain-text editor.

It turns out, we can convert this easily to \LaTeX{}
  - `create PAGE=ex01 page`
  - if you want to write your thesis in markdown and convert to \LaTeX{}, there's nothing wrong with that
  - for now, let's do some more examples to get a feel for markdown

## Example 02 -- more headings and lists 

Create a new file, `pages/resbaz/ex02.md`:

```
# Example 2

Today I am learning how to use \LaTeX{} like a pro.

## I set up tools

- command line tools
- VS Code IDE

## I learned to compile code

1. setting up tools
1. compiling to PDF
1. compiling to word

## I have the following objectives

- [x] learn markdown basics
- [ ] learn more markdown
- [ ] learn about Makefiles
```

Compile and view!

- `create PAGE=ex02 page`

## BONUS: examining output directory

This looks a little funny. We can fix the list.

First, let's get a little insight as to how these files are being generated

- expand `output` directory
- expand `output/pages/resbaz`
- an `ex02.tex` was auto-magically generated (based on Makefile rule, side note)
- open it up and take a look

This is really useful, there may be some cases where we want 
\LaTeX{} generated for us, and then modify what's already there

- example: changing [x] to a `todolist`
- make sure not to have the same name for a .tex as a .md in the same directory, otherwise the .tex will be ignored


## Example 03 -- tables

Create a new file, `pages/resbaz/ex03.md`:

```
# Table example 1

| Column 1 Header | Column 2 Header | Column 3 Header |
| --------------- | --------------- | --------------- |
| Row 1 Column 1 | Row 1 Column 2 | Row 1 Column 3 |
| Row 2 Column 1 | Row 2 Column 2 | Row 2 Column 3 |
| Row 3 Column 1 | Row 3 Column 2 | Row 3 Column 3 |
```

We can write this quicker

```
# Table example 2

I only need 3 dashes

| column 1 | column 2 | column 3 |
| --- | --- | --- |
| r1c1 | r1c2 | r1c3 |
| r2c1 | r2c2 | r2c3 |
```

- `create PAGE=ex03 page`

## Example 04 -- images and hyperlinks

Create a new file, `pages/resbaz/ex04.md`:

```
# Example 4

## Including images

![my figure caption](images/examples/image-a.png)

## Including links

My favorite search engine is [Duck Duck Go](https://duckduckgo.com).


```

- `create PAGE=ex04 page`





## Example 05 -- code, italics, and bold emphasis

```
# Bold

this text is **BOLD**

# Italic

this text is *italic*

if the text doesn't render as italic, we can embed \LaTeX{} 
commands, \textit{like so}

# Code

I can write code `in line`, or I can

```
write code in blocks
```

```

## Example 06 -- footnotes

Open `pages/footnotes.md`

- we won't type all of this up

---

At the end, add these files to `document.tex` and compile all of them

## Example 07 -- speaker notes

for a bit of fun, compile our speakernotes from markdown to PDF

- wait for participants
- show them where speakernotes are on github



Some remarks about our build tool

- talk through logic in Makefile
- .tex is always generated if there's an md file
  - if you don't want this, intervene manually
  - otherwise, tex files will get clobbered
  - you can rewrite this rule by modifying the `Makefile`

## Resources -- getting started with markdown

- https://www.markdownguide.org/basic-syntax/
- https://docs.github.com/en/github/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax
- https://www.markdownguide.org/extended-syntax/

---

# PAUSE FOR QUESTIONS

We have some options on what to learn next

- tour of build tool (make)
- creating our own rules
- modifying existing rules
- source control plug in

---

# Tour of Makefile

- What is a Makefile?
  - Make is a program that helps you compile code
  - The Makefile describes how this is to be done
  - `open our Makefile`
- What are targets?
  - these are the rules that describe how code can be compiled
    - for example `make pdf`
  - you can also write rules that tidy up your directory
    - for example `make clean`
    - show it cleaning up garbage from LaTeX Workshop
  - If there's time, we can write a target together later
- the Makefile included in our \LaTeX{} template provides several targets
  - do a demo

---

# Demo: show commands I use in my workflow (1)

Scenario

- I am a first year PhD student keeping an electronic notebook
- Every Monday I do `create timetracking` to generate a new weekly log

Goal

- I want to quickly generate a template for my work this week, including
  daily goals

Tasks
- I need to add the new page into `weekly_log.tex`
- I need to add notes
- I need to run `create PAGE=2022-11-18 week` to compile


# Demo: show commands I use in my workflow (2)

Scenario

- I am a first year PhD student keeping an electronic notebook
- I want to separate my research journal from my reference notes

Goal

- I want to quickly create a page to keep notes about a particular reference

Tasks
- I need to run `create PAGE=MyGreatSource note`
- I need to add the new page into `references.tex`
- I need to run `create ref` to compile


# Demo: writing a Makefile Target
Scenario

- I am a first year PhD student starting on my substantial piece of written work

Goal

- I need a fresh new document to begin working on this
- I want to automate compiling

Tasks
- create `thesis.tex` by copying from `document.tex`
- modify `Makefile` and add a new target 
  - add a new variable up at the top for `THESIS`
  - copy and modify rule for `weekly`
- I need to run `create thesis` to compile



---

# OTHER TOPICS

- demo the Source Control tool

---

# TROUBLESHOOTING

- if git isn't showing any updates, then
  - click refresh button
  - or...
    - open settings
    - `file -> preferences -> settings`
    - search for `git`
    - toggle `Git: Enabled`
- if pandoc says `Unknown option --citeproc`
  - please pull the docker image again
- `todolist`s don't render well when converting to ms word
    - this is a current limitation


- gotchas
    - search finds hits in `output` folder, take care to check file 
      before editing (so that you don't lose your work)
    - https://stackoverflow.com/questions/29971600/choose-folders-to-be-ignored-during-search-in-vs-code
      (exclude from search)
    - things like this mean the page hasn't been added to the main tex
    ```
    cd output && echo "\AtBeginDocument{\setcounter{chapter}{0}}" > /TEMP_2022-11-14.tex
    cd output && cat /2022-11-14.tex >> /TEMP_2022-11-14.tex
    cat: /2022-11-14.tex: No such file or directory
    make: *** [Makefile:159: page] Error 1
    ```


