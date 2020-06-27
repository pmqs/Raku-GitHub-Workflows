# action-setup-raku

![Linux build](https://github.com/pmqs/action-raku-test/workflows/Linux%20build/badge.svg)
![Windows build](https://github.com/pmqs/action-raku-test/workflows/Windows%20build/badge.svg)
![MacOS build](https://github.com/pmqs/action-raku-test/workflows/MacOS%20build/badge.svg)

This distribution contains a number of github actions for testing Raku (Perl6) modules on the following platforms

* Linux
* Windows
* MacOS.



To make use of these actions just copy the complete directory tree `.github` from this distribution.
You should now have a directory tree that looks like this.


```
YourModule
└── .github
    └── workflows
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

## linux.yml

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

## windows.yml

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

## macos.yml

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
