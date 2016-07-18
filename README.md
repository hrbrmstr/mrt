
`bgpdump` : Tools to Retrieve and Process 'BGP' Files

The following functions are implemented:

-   `get_latest_rib`: Retrieve the latest RouteViews RIB file
-   `get_rib`: Retrieve a specific, historical RouteViews RIB file
-   `rib_to_asn_table`: Convert RouteViews RIB (bgpdump table dump v2) to subnet/asn map

### Installation

``` r
devtools::install_github("hrbrmstr/bgpdump")
```

### Usage

``` r
library(bgpdump)

# current verison
packageVersion("bgpdump")
```

    ## [1] '0.1.0'

### Test Results

``` r
library(bgpdump)
library(testthat)

date()
```

    ## [1] "Mon Jul 18 15:30:07 2016"

``` r
test_dir("tests/")
```

    ## testthat results ========================================================================================================
    ## OK: 0 SKIPPED: 0 FAILED: 0
    ## 
    ## DONE ===================================================================================================================
