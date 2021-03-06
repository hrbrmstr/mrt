% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/routeviews.r
\name{get_latest_rib}
\alias{get_latest_rib}
\title{Retrieve the latest RouteViews RIB file}
\usage{
get_latest_rib(output_dir = ".", .progress = interactive())
}
\arguments{
\item{output_dir}{where the downloaded RIB should be stored}

\item{.progress}{show download progress (default: \code{FALSE})}
}
\value{
the filename (invisibly)
}
\description{
Retrieve the latest RouteViews RIB file
}
\note{
this function handles the UTC time zone adjustment properly
}
