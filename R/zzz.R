.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "\n",
    "─────────────────────────────────────────────────────────\n",
    "  You have loaded MoViz. Type `MoViz_help()` for guidance\n",
    "─────────────────────────────────────────────────────────"
  )
}