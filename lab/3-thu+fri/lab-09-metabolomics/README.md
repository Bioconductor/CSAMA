# Analysis and Annotation of Mass Spectrometry-based Metabolomics Data

Three tutorials/workshops are available describing general Mass Spectrometry
(MS) data handling and annotation of untargeted metabolomics data. CSAMA
participants can work on any of these two (or also on both) during the Thursday
and Friday afternoon labs. Installation instructions and general information for
both workshops are provided below. For questions, support etc get in touch with
Johannes Rainer or Laurent Gatto (see pictures below).

![Johannes Rainer](images/jorainer.png)
![Laurent Gatto](images/lgatto.png)


## A: `xcmsTutorials`

This workshop describes exploration and preprocessing of (untargeted) LC-MS data
with the [*MsExperiment*](https://github.com/RforMassSpectrometry/MsExperiment),
the [*Spectra*](https://github.com/RforMassSpectrometry/Spectra) and the
[*xcms*](https://github.com/sneumann/xcms) packages. This tutorial uses the
current developmental versions of the packages. The tutorial and related data is
provided as an R package and can be installed with
`BiocManager::install("jorainer/xcmsTutorials")`. The source code of the
workshop is available on [github](https://github.com/jorainer/xcmsTutorials)
which provides also installation instructions.

- Name of the workshop: **Exploring and analyzing LC-MS data with *Spectra* and *xcms***.
- github repository: https://github.com/jorainer/xcmsTutorials
- R package: `xcmsTutorials`.
- [Online (precompiled/rendered) version of the
  tutorial](https://jorainer.github.io/xcmsTutorials/articles/xcms-preprocessing.html)



## B: `SpectraTutorials`

This workshop explains the basic usage of the
[`Spectra`](https://www.bioconductor/packages/Spectra) Bioconductor package for
handling and analysing MS data. LC-MS/MS data from an untargeted
metabolomics experiment is loaded, processed and fragment (MS2) spectra are
compared against reference spectra.

The tutorial and related data is provided as an R package and can be installed
with `BiocManager::install("jorainer/SpectraTutorials")`. The source code of the
workshop is available on [github](https://github.com/jorainer/SpectraTutorials)
which provides also installation instructions. For this workshop it is suggested
to follow the [manual installation
instructions](https://github.com/jorainer/SpectraTutorials/#manual-installation).

- Name of the workshop: **Seamless Integration of Mass Spectrometry Data from
  Different Sources**.
- github repository: https://github.com/jorainer/SpectraTutorials
- R package: `SpectraTutorials`.
- [Online (precompiled/rendered) version of the
  tutorial](https://jorainer.github.io/SpectraTutorials/articles/analyzing-MS-data-from-different-sources-with-Spectra.html)
  


## C: `MetaboAnnotationTutorials`

This workshop illustrates how the
[`MetaboAnnotation`](https://www.bioconductor.org/packages/MetaboAnnotation)
Bioconductor package can be used to annotate untargeted metabolomics data.

The tutorial and related data is provided as an R package and can be installed
with `BiocManager::install("jorainer/MetaboAnnotationTutorials")`. The source
code of the workshop is available on
[github](https://github.com/jorainer/MetaboAnnotationTutorials).

- Name of the workshop: **Use Cases for Metabolomics Data Annotation Using the
  `MetaboAnnotation` package**.
- github repository: https://github.com/jorainer/MetaboAnnotationTutorials
- R package: `MetaboAnnotation`.
- [Online (precompiled/rendered) version of the
  tutorial](https://jorainer.github.io/MetaboAnnotationTutorials/articles/annotation-use-cases.html)
  

