# Raku GitHub Workflows

![Raku Caching Test](https://github.com/pmqs/Raku-GitHub-Workflows/workflows/Raku%20Caching%20Test/badge.svg)
![Linux Docker Test](https://github.com/pmqs/Raku-GitHub-Workflows/workflows/Linux%20Docker%20Test/badge.svg)
![Linux Star Docker Test](https://github.com/pmqs/Raku-GitHub-Workflows/workflows/Linux%20Star%20Docker%20Test/badge.svg)
![MacOS Star Test](https://github.com/pmqs/Raku-GitHub-Workflows/workflows/MacOS%20Star%20Test/badge.svg)
![Windows Star Test](https://github.com/pmqs/Raku-GitHub-Workflows/workflows/Windows%20Star%20Test/badge.svg)

This distribution contains a number of  GitHub workflows that can be used for testing [Raku](https://www.raku.org/) (Perl6) modules. The Raku code under `lib` and `t` is just dummy code that acts as a test harness for the worflows. Look in `.github/workflows` for the real deliverables from this dstribution.


## Summary of Workflows Available

The workflows vary in the amount of control they have over the version of Raku used and the OS they run on. The table below summarised the feature set available in each.


Workflow File | OS Supported | Raku Origin |  Uses [Rakudo Star](https://rakudo.org/star) | Control Raku Version Used | Option To Run Latest Raku | GitHub Cache Support
---|---|---|---|---|---|---
wf-caching.yml | Linux, MacOS & Windows | [Radudo Downloads](https://rakudo.org/downloads/rakudo) | No | Yes | Yes | Yes
wf-linux-docker.yml | Linux | [Docker](https://hub.docker.com/r/jjmerelo/alpine-raku) | No | Yes | Yes | No
wf-linux-star-docker.yml | Linux | [Rakudo Star Official Docker](https://hub.docker.com/_/rakudo-star/) | Yes | Yes | Yes | No
wf-macos-star.yml |  MacOS | [Homebrew](https://github.com/Homebrew/homebrew-core/blob/master/Formula/rakudo-star.rb) | Yes | No  | No | No
wf-windows-star.yml | Windows | [Chocolatey](https://chocolatey.org/packages/rakudostar)  | Yes |  No | No | No

## Which should you use?

For casual testing, one of the workflows that use [Rakudo Star](https://rakudo.org/star) is a good starting point. They usually have a relatively recent build of Raku, plus they come with a set of commonly used modules. Less chance of needing any prerequisite modules to be installed.

## Why you may need a Caching Workflow

All the workflows use the [zef](https://github.com/ugexe/zef) Module Manager to automatically install Raku depencencies. If you are using a workflow that uses [Rakudo Star](https://rakudo.org/star) there may be no need to install any dependencies. [Rakudo Star](https://rakudo.org/star) may already include them.

If you have a use-case where your module dependencies are not present in a [Rakudo Star](https://rakudo.org/star) distribution, and you are not using workflow caching, those dependencies will get resolved by [zef](https://github.com/ugexe/zef) every time the workflow runs.

At the time of writing, installing Raku module dependencies can take a *long* time to run -- 5 minutes is typical. This is where a caching workflow can help. The `wf-caching.yml` workflow has been setup to use a GitHub cache to store all the modules that [zef](https://github.com/ugexe/zef) installs.

This means that the first time you run the workflow you will take the 5 minute hit, but the subsequent runs should be competed in seconds.


## Limitations of Caching

GitHub will only retain the cache for about a week if it isn't accessed.

Also, if the module you are using gets updated, and you already have an older version in the GitHub cache



## Controlling wf-caching.yml

There are two things you can

the releases are sourced from [Radudo Downloads](https://rakudo.org/downloads/rakudo). The special release `latest` will automatiocally pick the most recent version.

```yaml
      matrix:
        os:
          - macos-latest
          - ubuntu-latest
          - windows-latest

        raku-release:
          - latest
#           - 2020.06
```




To make use of these workflows just copy the complete directory tree `.github` from this distribution.
You should now have a directory tree that looks like this.


```
YourModule
└── .github
    └── workflows
        ├── test.yml
        ├── linux.yml
        ├── windows.yml
        └── macos.yml

```

And that's it. Every Git push or pull request will now trigger a test run.


Note that these actions assume you have structured your source based on the guidelines in the Raku document [Distributing Modules](https://docs.raku.org/language/modules#Distributing_modules). At a minimum that means your source should be in the `lib` sub-directory and tests are in the `t` directory. Something like this:

 ```
HelloWorld/
├── lib
│   └── HelloWorld
└── t
    └── basic.t
```


Below are the actions for each of the supported platforms.

## Simple Workflows

### Linux

This action uses a container-based distribution on Docker to read the Raku binaries.

Only Ubuntu was supported at the time of writing.

You can change the version of Raku, by editing edit the `container` line. See the [Tags](https://hub.docker.com/r/jjmerelo/alpine-raku/tags)
for the list ov available Raku versions. setting it to `latest` will do what you expect.


```yaml
name: Linux build

on: [push, pull_request]

jobs:
  build:

    runs-on: ubuntu-latest

    container: jjmerelo/alpine-raku:latest

    steps:

    - name: Checkout
      uses: actions/checkout@v1

    - name: Raku version
      run: raku -v

    - name: Install dependencies
      run: zef install --deps-only .

    - name: Run tests
      run: zef test --verbose .
```

### Windows

This one uses the [Rakudo Star](https://rakudo.org/star) bundle that is available in Chocolatey

```yaml
name: Windows build

on: [push, pull_request]

jobs:
  build:

    runs-on: windows-latest

    steps:

    - uses: actions/checkout@v2

    - name: Install Rakudostar
      run: |
        choco install rakudostar
        echo "::add-path::C:\rakudo\bin"
        echo "::add-path::C:\rakudo\share\perl6\site\bin"

    - name: Raku version
      run: perl6 -v

    - name: Install Module dependencies
      run: zef install --deps-only .

    - name: Run tests
      run: zef test --verbose .
```

### MacOS

This one uses the [Rakudo Star](https://rakudo.org/star) bundle that is available in Brew.


```yaml
name: MacOS build

on: [push, pull_request]

jobs:
  build:

    runs-on: macos-latest

    steps:

    - uses: actions/checkout@v2

    - name: Install Raku
      run: brew install rakudo-star

    - name: Raku version
      run: raku -v

    - name: Install Module dependencies
      run: zef install --deps-only .

    - name: Run tests
      run: zef test --verbose .
```
