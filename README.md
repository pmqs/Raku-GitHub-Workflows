# Raku GitHub Workflows

![Raku Caching Test](https://github.com/pmqs/Raku-GitHub-Workflows/workflows/Raku%20Caching%20Test/badge.svg)
![Linux Docker Test](https://github.com/pmqs/Raku-GitHub-Workflows/workflows/Linux%20Docker%20Test/badge.svg)
![Linux Star Docker Test](https://github.com/pmqs/Raku-GitHub-Workflows/workflows/Linux%20Star%20Docker%20Test/badge.svg)
![MacOS Star Test](https://github.com/pmqs/Raku-GitHub-Workflows/workflows/MacOS%20Star%20Test/badge.svg)
![Windows Star Test](https://github.com/pmqs/Raku-GitHub-Workflows/workflows/Windows%20Star%20Test/badge.svg)

This distribution contains a number of  GitHub workflows that can be used for testing [Raku](https://www.raku.org/) (Perl6) modules. The Raku code under `lib` and `t` is just dummy code that acts as a test harness for the workflows. Look in `.github/workflows` for the real deliverables from this dstribution.


## Summary of Workflows Available

The workflows vary in the amount of control they have over the version of Raku used and the OS they run on. The table below summarised the feature set available in each.


Workflow File | OS Supported | Raku Origin |  Uses [Rakudo Star](https://rakudo.org/star) | Control Raku Version Used | Option To Run Latest Raku | GitHub Cache Support
---|---|---|---|---|---|---
wf-caching.yml | Linux, MacOS & Windows | [Rakudo Downloads](https://rakudo.org/downloads/rakudo) | No | Yes | Yes | Yes
wf-linux-docker.yml | Linux | [Docker](https://hub.docker.com/r/jjmerelo/alpine-raku) | No | Yes | Yes | No
wf-linux-star-docker.yml | Linux | [Rakudo Star Official Docker](https://hub.docker.com/_/rakudo-star/) | Yes | Yes | Yes | No
wf-macos-star.yml |  MacOS | [Homebrew](https://github.com/Homebrew/homebrew-core/blob/master/Formula/rakudo-star.rb) | Yes | No  | No | No
wf-windows-star.yml | Windows | [Chocolatey](https://chocolatey.org/packages/rakudostar)  | Yes |  No | No | No

## Which one should you use?

For casual testing, one of the workflows that use [Rakudo Star](https://rakudo.org/star) is a good starting point. They usually have a relatively recent build of Raku, plus they come with a set of commonly used modules. Less chance of needing any prerequisite modules to be installed.

## Why you may need a Caching Workflow

All the workflows use the [zef](https://github.com/ugexe/zef) Module Manager to automatically install Raku depencencies. If you are using a workflow that uses [Rakudo Star](https://rakudo.org/star) there may be no need to install any. [Rakudo Star](https://rakudo.org/star) may already include them.

If you have a use-case where your module dependencies are not present in a [Rakudo Star](https://rakudo.org/star) distribution, and you are not using workflow caching, those dependencies will get resolved by [zef](https://github.com/ugexe/zef) every time the workflow runs.

At the time of writing, installing Raku module dependencies can take a *long* time to run -- 5 minutes is typical. This is where a caching workflow can help. The `wf-caching.yml` workflow has been setup to use a GitHub cache to store all the modules that [zef](https://github.com/ugexe/zef) installs.

This means that the first time you run the workflow you will take the 5 minute hit, but the subsequent runs should be completed in seconds.


## Limitations of Caching

GitHub will only retain the cache for about a week if it isn't accessed.


## Support

Suggestions/patches/comments are welcomed at [Raku-GitHub-WorkFlows](https://github.com/pmqs/Raku-GitHub-Workflows)
