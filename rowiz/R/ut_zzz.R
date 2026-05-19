.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "\n",
    "─────────────────────────────────────────────────────────\n",
    "  You have loaded Rowiz. Type `Rowiz_help()` for guidance\n",
    "─────────────────────────────────────────────────────────"
  )
}