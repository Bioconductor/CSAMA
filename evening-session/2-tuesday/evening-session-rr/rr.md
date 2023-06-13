# Open and reproducible research

Laurent Gatto and Charlotte Soneson

## Pitch

![](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.y997ex9YBpOb2hp7wxBaKAHaLY%26pid%3DApi&f=1&ipt=1f220e3849ba9b03fc675b172270af21303fe6cd78037eb8c8e9bc142869e4bd&ipo=images)

## Motivation

### Inverse problems

Inverse problems are hard

Example and figure borrowed from [Stephen Eglen](https://sje30.github.io/talks/2017/cam_eglen.html#inverse-problems-are-hard).

| Score (%) | grade |
|:---------:|:-----:|
| 70-100    |    A  |
| 60-69     |    B  |
| 50-59     |    C  |
| 40-49     |    D  |
| 0-39      |    F  |


- **Forward problem**: I scored 68, what was my grade?
- **Inverse problem**: I got a B, what was my score?

**Research sharing**: the inverse problem

![](https://lgatto.github.io/images/inv-paper.svg)

### Where is the scholarship?

> An article about computational science in a scientific publication
> is not the scholarship itself, it is merely advertising of the
> scholarship. The actual scholarship is the complete software
> development environment and that complete set of instructions that
> generated the figures.

[Buckheit and Donoho 1995, after Claerbout]

### The R words

From a [*But what to we mean by reproducibility?*](https://lgatto.github.io/rr-what-should-be-our-goals/) blog post.

- **Repeat** my experiment, i.e. obtain the same tables/graphs/results
  using the same setup (data, software, ...) in the same lab or on the
  same computer. That's basically re-running one of my analysis some
  time after I original developed it.
- **Reproduce** an experiment (not mine), i.e. obtain the same
  tables/graphs/results in a different lab or on a different computer,
  using the same setup (the data would be downloaded from a public
  repository and the same software, but possibly different version,
  different OS, is used). I suppose, we should differentiate
  replication using a fresh install and a virtual machine or docker
  image that replicates the original setup.
- **Replicate** an experiment, i.e. obtain the same (similar enough)
  tables/graphs/results in a different set up. The data could still be
  downloaded from the public repository, or possibly
  re-generate/re-simulate it, and the analysis would be re-implemented
  based on the original description. This requires openness, and one
  would clearly not be allowed the use a black box approach (VM,
  docker image) or just re-running a script.
- Finally, **re-use** the information/knowledge from one experiment to
  run a different experiment with the aim to confirm results from
  scratch.

Another view (from a talk by [Kirstie Whitaker](https://figshare.com/articles/Publishing_a_reproducible_paper/4720996/1)):

|                    | Same Data | Different Data |
|--------------------|-----------|----------------|
| **Same Code**      | reproduce | replicate      |
| **Different Code** | robust    | generalisable  |


See also this opinion piece by Jeffrey T. Leek and Roger D. Peng,
[*Reproducible research can still be wrong: Adopting a prevention
approach*](https://www.pnas.org/content/112/6/1645).

### Discussion points

- Open vs reproducible
- Why working reproducibly?
- Is working reproducible difficult? Does it take more time?
- What tools do you use to work reproducibly/openly?
- Cost benefit of reproducible research.
- Should every piece of work be reproducible?

<hr>

## Open vs reproducible

- open != reproducible, but they often go hand in hand
- open != good (by default)
- reproducible != good (by default)


## Why working reproducibly?

Reproducible != correct, but reproducible -> trust.

From

> Gabriel Becker [*An Imperfect Guide to Imperfect
> Reproducibility*](https://gmbecker.github.io/MayInstituteKeynote2019/outline.html),
> May Institute for Computational Proteomics, 2019.


**(Computational) Reproducibility Is Not The Point**

Take home message:

> The goal is **trust**, **verification** and **guarantees**:

- **Trust in Reporting** - result is accurately reported
- **Trust in Implementation** - analysis code successfully implements
  chosen methods
- **Statistical Trust** - data and methods are (still) appropriate
- **Scientific Trust** - result convincingly supports claim(s) about
  underlying systems or truths

Reproducibility As A Trust Scale (copyright Genentech Inc)

![Reproducibility As A Trust Scale](https://gmbecker.github.io/MayInstituteKeynote2019/trustscale3.png)

## More reasons to become a reproducible research practitioner

Florian Markowetz, [**Five selfish reasons to work reproducibly**](https://doi.org/10.1186/s13059-015-0850-7), Genome Biology 2015, 16:274.

![Five selfish reasons to work reproducibly](https://lgatto.github.io/images/2017-09-22-selfish-rr.png)

> And so, my fellow scientists: ask not what you can do for
> reproducibility; ask what reproducibility can do for you! Here, I
> present five reasons why working reproducibly pays off in the long
> run and is in the self-interest of every ambitious, career-oriented
> scientist.

1. **Reproducibility helps to avoid disaster**: a project is more than
   a beautiful result. You need to record in detail how you got
   there. Starting to work reproducibly early on will save you time
   later. I had cases where a collaborator told me they preferred the
   results on the very first plots they received, that I couldn't
   recover a couple of month later. But because my work was
   reproducible and I had tracked it over time (using git and GitHub),
   I was able, after a little bit of data analysis forensics, to
   identify why these first, preliminary plots weren't consistent with
   later results (and it as a simple, but very relevant bug in the
   code). Imagine if my collaborators had just used these first plots
   for publication, or to decide to perform further experiments.
2. **Reproducibility makes it easier to write papers**: Transparency
   in your analysis makes writing papers much easier. In dynamic
   documents (using [rmarkdown](http://rmarkdown.rstudio.com/),
   [Quarto](https://quarto.org/), [Juypter
   notebook](https://jupyter.org/) and other similar tools), all
   results are automatically update when the data are changed. You can
   be confident your numbers, figures and tables are up-to-date.
3. **Reproducibility helps reviewers see it your way**: a reproducible
   document will tick many of the boxes enumerated above. You will
   make me very happy reviewer if I can review a paper that is
   reproducible.
4. **Reproducibility enables continuity of your work:** quoting
   Florian, "In my own group, I don't even discuss results with
   students if they are not documented well. No proof of
   reproducibility, no result!".
5. **Reproducibility helps to build your reputation:** publishing
   reproducible research will build you the reputation of being an
   honest and careful researcher. In addition, should there ever be a
   problem with a paper, a reproducible analysis will allow to track
   the error and show that you reported everything in good faith.


## Working reproducible is difficult

- both for those that want others to reproduce their work, and for those trying to reproduce others


## Does it take more time to work reproducibly?

**No**, it is a matter or relocating time!

![](https://lgatto.github.io/images/reproducibiity_relocates_time.png)

## Tools for RR

- R markdown, Quarto
- Git/GitHub - https://happygitwithr.com/
- Docker
- [workflowr](https://workflowr.io/)
  ([Example](https://oshlacklab.com/paed-cf-cite-seq/index.html) from
  a recent
  [preprint](https://www.biorxiv.org/content/10.1101/2022.06.17.496207v1))
- Makefile, [Snakemake](https://snakemake.readthedocs.io/en/stable/),
  [targets] https://docs.ropensci.org/targets/] package
- [protocols.io](https://www.protocols.io/)
- [renv](https://rstudio.github.io/renv/articles/renv.html)
- ...
