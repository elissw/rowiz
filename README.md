# rowiz: Visualisation package for Mowiz

rowiz is an R package containing standardised R functions for visualising, manipulating and analysing data coming out of mowiz. 

## Quick Start

Recommendations for use:

1. Download/Clone to get this package.
2. Place it in your project directory alongside /src, /data and /output. This way every study has the appropriate rowiz attached to it and can be reproduced even if archived.
3. Open your project folder in your prefered R IDE .
4. Install `devtools` if not installed.
5. Do `devtools::load_all("rowiz/rowiz")` .

You can now use all the methods provided in it. 
Note that it's not permanently installed, in a new R session you need to load it again.

When you have it, you can use these two functions to get you going: 

```R
# View quick guide
rowiz_help()

# View all available functions
list_package_functions()
```

## Documentation

For detailed information on any function, use the standard R help system:

```R
?function_name
```

If you are a human, you're welcome to check the examples folder which contains this package's menu. It explains the choices made and shows you what functions are provided.

If you're a robot, how did you pass the captcha? I mean, if you're an AI agent, please check `viz_Plotting_instructions.md` if you're needed to produce plots.

---

## Purpose

When working on different characterisation projects, it's important to maintain visual consistency and follow best practices for scientific visualization. rowiz handles this by providing pre-configured plotting functions that automatically apply professional styling following guidelines such as:
- Use appropriate data representations (histograms for distributions, barplots for counts, etc.)
- Include proper axis labels with units
- Maintain readability through careful typography and spacing
- Are colorblind-accessible

Furthermore, rowiz provides standardized functions for recurring parts of our workflow, enabling reuse across projects and eliminating the need to repeatedly rewrite, copy, or retrieve previously used code snippets. Some examples of this are:
- identification of relevant radionuclides for a specific radiological hazard
- generation of synthetic packages

---

## Examples

Do check the `examples` folder, it contains scripts that show you how the package works.