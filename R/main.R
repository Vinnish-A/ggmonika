ggmonika_db = function() {
  list(
    monika = list(default = c("#94697a", "#394c81", "#82c93f", "#d1897e", "#b9c1f1", "#c0071b", "#febee1", "#1d3064"))
  )
}

manual_pal_rev = function (values) {
  force(values)
  function(n) {
    n_values = length(values)
    if (n > n_values) {
      cli::cli_warn("This manual palette can handle a maximum of {n_values} values. You have supplied {n}")
    }
    rev(unname(values[seq_len(n)]))
  }
}

manual_pal = function (values) {
  force(values)
  function(n) {
    n_values = length(values)
    if (n > n_values) {
      cli::cli_warn("This manual palette can handle a maximum of {n_values} values. You have supplied {n}")
    }
    unname(values[seq_len(n)])
  }
}

#' Monika Palettes
#'
#' Color palettes inspired by Monika
#'
#' @param palette Palette type.
#' Currently there is one available option: \code{"default"}
#' (8-color palette inspired by \emph{Monika}).
#' @param alpha Transparency level, a real number in (0, 1].
#' See \code{alpha} in \code{\link[grDevices]{rgb}} for details.
#' @param reverse Whether or not to reverse color
#'
#' @export pal_monika
#'
#' @importFrom grDevices col2rgb rgb
#' @importFrom scales manual_pal
#'
#' @examples
#' library("scales")
#' show_col(pal_monika("default")(10))
#' show_col(pal_monika("default", alpha = 0.6)(10))
pal_monika = function (palette = c("default"), alpha = 1, reverse = FALSE) {
  palette = match.arg(palette)
  if (alpha > 1L | alpha <= 0L)
    stop("alpha must be in (0, 1]")
  raw_cols = ggmonika_db()[['monika']][[palette]]
  raw_cols_rgb = col2rgb(raw_cols)
  alpha_cols = rgb(raw_cols_rgb[1L, ], raw_cols_rgb[2L, ],
                    raw_cols_rgb[3L, ], alpha = alpha * 255L, names = names(raw_cols),
                    maxColorValue = 255L)
  if (reverse) manual_pal_rev(unname(alpha_cols)) else manual_pal(unname(alpha_cols))
}

#' Monika Color Scales
#'
#' See \code{\link{pal_monika}} for details.
#'
#' @inheritParams pal_monika
#' @param ... additional parameters for \code{\link[ggplot2]{discrete_scale}}
#'
#' @export scale_color_monika
#'
#' @importFrom ggplot2 discrete_scale
#'
#' @examples
#' library("ggplot2")
#' data("diamonds")
#'
#' ggplot(
#'   subset(diamonds, carat >= 2.2),
#'   aes(x = table, y = price, colour = cut)
#' ) +
#'   geom_point(alpha = 0.7) +
#'   geom_smooth(method = "loess", alpha = 0.1, size = 1, span = 1) +
#'   theme_bw() +
#'   scale_color_monika()
#'
#' ggplot(
#'   subset(diamonds, carat > 2.2 & depth > 55 & depth < 70),
#'   aes(x = depth, fill = cut)
#' ) +
#'   geom_histogram(colour = "black", binwidth = 1, position = "dodge") +
#'   theme_bw() +
#'   scale_fill_monika()
scale_color_monika = function (palette = c("default"), alpha = 1, reverse = FALSE, ...) {
  palette = match.arg(palette)
  discrete_scale("colour", "monika", pal_monika(palette, alpha, reverse), ...)
}

#' @export scale_colour_monika
scale_colour_monika = scale_color_monika

#' Monika Fill Scales
#'
#' @export scale_fill_monika
#' @importFrom ggplot2 discrete_scale
scale_fill_monika = function (palette = c("default"), alpha = 1, reverse = FALSE, ...) {
  palette = match.arg(palette)
  discrete_scale("fill", "monika", pal_monika(palette, alpha, reverse), ...)
}



