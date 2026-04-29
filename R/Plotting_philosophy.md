# Visual Standards for Data Plots
*R Visualization Package – Design Rationale*

## 1. Purpose of this package

This package does not only provide plotting functions.  
It enforces a **consistent visual standard** for all figures produced by the team.

The goal is that any plot created with this package is:

- Readable from a distance (presentations, conferences, large screens)
- Safe to print and embed in reports without quality loss
- Immediately understandable without visual clutter
- Consistent across people, projects, and time
- Focused on the data, not on decoration

---

## 2. General Visual Philosophy

The design of the plots follows a simple rule:

> The data must be the most visible element in the figure.

Everything else (grid, text, legend, colors, margins) exists only to support readability.

The plots are designed to be:

- Calm
- Professional
- Minimal
- Robust to resizing and projection
- Accessible (including color vision deficiencies)

---

## 3. Figure Geometry and Resolution

### Aspect ratio: **1 : 1.4**

This ratio was chosen because it works reliably across:

- PowerPoint slides
- Printed reports
- Conference projections
- Side-by-side figure layouts

It provides enough horizontal space for legends and annotations without compressing the data area.

### Resolution: **300 DPI**

All plots are exported at 300 DPI to ensure:

- No pixelization when projected on large screens
- High print quality
- Resistance to image compression when inserted into slides or documents

This makes every figure “conference-safe” and “print-safe” by default.

---

## 4. Typography Hierarchy

Font sizes are carefully chosen to preserve readability when the plot is resized.

| Element        | Size |
|----------------|------|
| Title          | 14   |
| Subtitle       | 10   |
| Axis titles    | 13   |
| Axis text      | 12   |
| Legend title   | 12   |
| Legend text    | 11   |
| Caption        | 8    |

This creates a clear visual hierarchy:

**Title → Data → Axes → Legend → Caption**

Tiny fonts are deliberately avoided to prevent unreadable plots in presentations.

---

## 5. Legend Placement

Legends are placed **on the right**.

Reasons:

- Preserves vertical space for the data
- Works naturally with the 1:1.4 aspect ratio
- Prevents legends from compressing the plotting area
- Keeps the reading flow left (data) → right (context)

Large, intrusive legends are avoided.

---

## 6. Grid and Background

Background is always **white**.

Grid design:

- Major grid: light gray, dotted
- Minor grid: removed

This creates:

- A reference structure for reading values
- Without attracting attention away from the data
- A “present but discreet” guide for the eye

No heavy borders, no dark backgrounds, no visual noise.

---

## 7. Color Philosophy

### For 3 or more colors
Palette: **viridis**

Reasons:

- Perceptually uniform
- Colorblind-safe
- Professional and calm tones
- Good contrast on white background

### For 2 colors only
Custom pair: **cadetblue** and **coral**

Reason:

The first two colors of viridis (purple and yellow) provide poor contrast on white when used alone.  
This custom pair ensures immediate visual distinction without harsh contrast.

Color is never used decoratively — only to encode information.

---

## 8. Annotation Style

Annotations are kept **minimal**:

- Plain text directly on the plot whenever possible
- A white background box is used **only** when text must overlap data
- Positioning avoids covering data whenever possible

This prevents annotations from becoming visual obstacles.

---

## 9. Margins and Breathing Space

Margins are standardized:

```r
plot.margin = unit(c(14, 18, 14, 14), "pt")
```

This ensures:

- Plots never feel cramped
- Titles, legends, and data have breathing room
- Consistent alignment across different figures

---

### 10. What This Package Intentionally Avoids

The following are deliberately excluded because they reduce clarity:

- 3D effects or perspective plots
- Decorative themes
- Excessive ink or heavy styling
- Tiny unreadable text
- Rainbow or high-saturation palettes
- Busy legends that dominate the figure
- “Spreadsheet-style” visuals

---

### 11. The Intended Result

A plot produced with this package should:

- Look calm and professional
- Be readable from the back of a conference room
- Work in slides, reports, and print without adjustment
- Look consistent no matter who produced it
- Let the data speak first