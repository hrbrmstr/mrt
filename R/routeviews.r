#' Retrieve the latest RouteViews RIB file
#'
#' @param output_dir where the downloaded RIB should be stored
#' @param .progress show download progress (default: \code{FALSE})
#' @note this function handles the UTC time zone adjustment properly
#' @return the filename (invisibly)
#' @export
get_latest_rib <- function(output_dir=".", .progress=FALSE) {

  tdy <- Sys.time()

  hr <- as.numeric(format(tdy, "%H", tz="UTC"))
  hr <- ifelse(((hr %% 2) == 0), hr, hr-1)

  day <- format(tdy, "%Y-%m-%d", tz="UTC")

  get_rib(day, hr, output_dir, .progress)

}

#' Retrieve a specific, historical RouteViews RIB file
#'
#' @param date the date (`YYYY-mm-dd` string or \code{Date}) of the file (remembering
#'        that the filenames are in UTC time zone)
#' @param hour the hour of the file (remembering that RouteViews dumps a RIB every 2 hours)
#' @param .progress show download progress (default: \code{FALSE})
#' @return the filename (invisibly)
get_rib <- function(date, hour, output_dir=".", .progress=FALSE) {

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
