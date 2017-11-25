#' Retrieve the latest RouteViews RIB file
#'
#' @param output_dir where the downloaded RIB should be stored
#' @param .progress show download progress (default: \code{FALSE})
#' @note this function handles the UTC time zone adjustment properly
#' @return the filename (invisibly)
#' @export
get_latest_rib <- function(output_dir=".", .progress=interactive()) {

  sprintf(
    "http://archive.routeviews.org/bgpdata/%s/RIBS/",
    format(Sys.Date(), "%Y.%m")
  ) -> rv_url

  res <- httr::GET(rv_url)
  res <- httr::content(res)
  rvest::html_node(
    res,
    xpath=".//a[contains(@href, 'rib.') and position()=last()]"
  ) -> res
  res <- rvest::html_text(res)

  res <- sprintf("%s%s", rv_url, res)

  curd <- getwd()
  setwd(output_dir)

  curl::curl_download(res, basename(res), quiet=!(.progress))

  setwd(curd)

  return(invisible(basename(res)))


}

#' Retrieve a specific, historical RouteViews RIB file
#'
#' @param date the date (`YYYY-mm-dd` string or \code{Date}) of the file (remembering
#'        that the filenames are in UTC time zone)
#' @param hour the hour of the file (remembering that RouteViews dumps a RIB every 2 hours)
#' @param .progress show download progress (default: \code{FALSE})
#' @export
#' @return the filename (invisibly)
get_rib <- function(date, hour, output_dir=".", .progress=interactive()) {

  output_dir <- path.expand(output_dir)
  if (!file.exists(output_dir)) stop("Output directory not found", call.=FALSE)

  date_dir <- format(as.Date(date), "%Y.%m")
  day_fil <- format(as.Date(date), "%Y%m%d")

  URL <- sprintf("ftp://archive.routeviews.org/bgpdata/%s/RIBS/rib.%s.%s.bz2",
                 date_dir, day_fil, sprintf("%02d00", as.numeric(hour)))

  fil <- file.path(output_dir, basename(URL))

  message(URL)

  curl::curl_download(URL, fil, quiet=!(.progress))

  return(invisible(fil))

}
