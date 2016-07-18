
`mrt` : Tools to Retrieve and Process 'BGP' Files

### Requirements

This package links to [`libBGPdump`](https://bitbucket.org/ripencc/bgpdump/wiki/Home).

On macOS, you can do the following to install the libary:

    brew install bgpdump

On Ubuntu/Debian (or prbly any other one) you can do the following to install the library:

    sudo apt-get install -y mercurial libbz2-dev zlib1g-dev
    hg clone https://bitbucket.org/ripencc/bgpdump
    cd bgpdump
    ./bootstrap.sh
    make
    sudo make install

(you may need to use `ldconfig` after that depending on your system)

The following functions are implemented:

-   `get_latest_rib`: Retrieve the latest RouteViews RIB file
-   `get_rib`: Retrieve a specific, historical RouteViews RIB file
-   `rib_to_asn_table`: Convert RouteViews RIB (bgpdump table dump v2) to subnet/asn map

### Installation

``` r
devtools::install_github("hrbrmstr/mrt")
```

### Usage

``` r
library(mrt)

# current verison
packageVersion("mrt")
```

    ## [1] '0.1.0'

### Test Results

``` r
library(mrt)
library(testthat)

date()
```

    ## [1] "Mon Jul 18 17:47:04 2016"

``` r
test_dir("tests/")
```

    ## Loading required package: bgpdump

    ## 
    ## Attaching package: 'bgpdump'

    ## The following objects are masked from 'package:mrt':
    ## 
    ##     get_latest_rib, rib_to_asn_table

    ## testthat results ========================================================================================================
    ## OK: 0 SKIPPED: 0 FAILED: 0
    ## 
    ## DONE ===================================================================================================================
