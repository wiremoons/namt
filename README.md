[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/hyperium/hyper/master/LICENSE) [![namt](https://github.com/wiremoons/namt/actions/workflows/sxl-build-nim.yml/badge.svg?branch=main)](https://github.com/wiremoons/namt/actions/workflows/namt-build-nim.yml)

# namt
Nim Acronym Management Tool (NAMT) manages acronyms stored in a SQLite database.

## Application Usage

Under early development

## Development Information

The application in written using the Nim programming language, so can be used on any supported operating systems such as Windows, Linux, FreeBSD, etc. More information about Nim is available here:

 - [Nim's web site](https://nim-lang.org/)
 - [Nim on GitHub](https://github.com/nim-lang/Nim)

## Building and Installing from Source 

If you wish to build `namt` application yourself, then the instructions below should help. These cover Windows and Linux specifically, but hopefully they will help for other platforms too.

### Linux

The instruction below are for Linux, and have been tested on Ubuntu 20.04.2 LTS (aarch64 and x64) and macOS 'Bug Sur' 11.4.

To build 'namt' from source on a Linux based system, the following steps can be used:

1. Install the Nim compiler and a C compiler such as GCC or Clangs, plus the OpenSSL library. More information on installing Nim can be found here: [Nim Download](https://nim-lang.org/install.html).
2. Once Nim is installed and working on your system, you can clone this GitHub repo with the command: `git clone https://github.com/wiremoons/namt.git`
3. Then in the cloned code directory for `namt` use Nimble to build a release version with the command: `nimble release`.   Other Nimble build commands can be seen by running: `nimble tasks`.
4. The compiled binary named `namt` can now be found in the `./bin` sub directory. Just copy it somewhere in you path, and it should work when run.

### Windows 10

The instruction below have been tested on Windows 10 only, but should perform the same on most older versions too.

The quickest way I have found to install Nim and then build the `namt` program your self is following the steps:

1. Open a Powershell command line window
2. Install the packages manager [scoop](https://scoop.sh/) by running: `iwr -useb get.scoop.sh | iex`
3. Install the packages: Nim; OpenSSL; Git; and GCC: `scoop install nim openssl git gcc`
4. Clone the *namt* projects to your computer: `git clone https://github.com/wiremoons/namt.git`
5. Change directory into the newly create source directory :  `cd namt`
6. Build the *namt* application: `nimble release`
7. The build binary file should be located in the `bin` sub directory - run it with: `.\bin\namt.exe`

You should now copy the `namt.exe` file to a directory in your PATH to make it easier to use. Before it will work,
the set up needs to be completed, as below:

## Installing a Binary Version

One of the key benefits of having an application developed in Nim is that the resulting application is compiled in to a single binary file. The Windows version also requires a OpenSSL library, that is used to secure the communications with the API web site.

If you have [Nimble](https://github.com/nim-lang/nimble) installed on your system, this program can be installed with the command:
```
nimble install https://github.com/wiremoons/namt
```

## Acknowledgments and Other Info

The application would not be possible without the use of [SQLite](https://www.sqlite.org).

If you are interested in reading about what I have been programming in Nim, then you can find several Nim related articles on my blog here: [www.wiremoons.com](http://www.wiremoons.com/).

## License

The `namt` application is provided under the *MIT* open source license. A copy of the MIT license file is [here](./LICENSE).

The [SQLite](https://www.sqlite.org) is provided under the *Public Domain* open source license. A copy of the license file is [here](https://github.com/sqlite/sqlite/blob/master/LICENSE.md) and fuller information [here](https://www.sqlite.org/copyright.html).
