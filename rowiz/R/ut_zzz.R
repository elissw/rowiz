.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "\n",
    "─────────────────────────────────────────────────────────\n",
    "  You have loaded Rowiz. Type `rowiz_help()` for guidance\n",
    "─────────────────────────────────────────────────────────"
  )
}