import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import iqr

# Load the dataframe
df = pd.read_csv("items_TFA_sherpa_2025_a_itm.csv")

# Filter for items only (component_id == 0)
df_items = df[df['component_id'] == 0].copy()

# Extract dose rate data
dose_rate_10cm = df_items['DR_10cm_uSv_h'].dropna()

# Calculate binwidth using Freedman-Diaconis rule for log-transformed data
log_dose_rate = np.log10(dose_rate_10cm)
iqr_val = iqr(log_dose_rate, nan_policy='omit')
n = len(log_dose_rate)
binwidth_log = 2 * iqr_val / (n ** (1/3))

# Create bins on log scale
log_min = np.log10(dose_rate_10cm.min())
log_max = np.log10(dose_rate_10cm.max())
num_bins = int((log_max - log_min) / binwidth_log)
log_bins = np.linspace(log_min, log_max, num_bins)
bins = 10 ** log_bins

# Create the plot
fig, ax = plt.subplots(figsize=(8, 6), dpi=100)

# Plot histogram as step plot (like geom_histogram_custom in R)
ax.hist(dose_rate_10cm, bins=bins, 
        histtype='step',
        color='#5F9EA0',  # cadetblue
        linewidth=0.8)

# Set log scale on x-axis
ax.set_xscale('log')

# Labels
ax.set_xlabel('Dose rate @ 10cm [uSv/h]', fontsize=13, fontweight='bold')
ax.set_ylabel('Number of items', fontsize=13, fontweight='bold')

# Professional styling - mimic theme_professional()
ax.grid(True, which='major', linestyle=':', color='gray', alpha=0.7)
ax.grid(True, which='minor', linestyle=':', color='gray', alpha=0.3)
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.spines['left'].set_linewidth(0.6)
ax.spines['bottom'].set_linewidth(0.6)
ax.tick_params(which='both', width=0.6, labelsize=12)

# Set background
ax.set_facecolor('white')
fig.patch.set_facecolor('white')

# Adjust margins
plt.subplots_adjust(left=0.14, right=0.95, top=0.95, bottom=0.12)

# Save the plot
plt.savefig('dose_rate_distribution_10cm_python.png', dpi=300, bbox_inches='tight', facecolor='white')
print(f"Plot saved as dose_rate_distribution_10cm_python.png")
print(f"Number of items plotted: {len(dose_rate_10cm)}")
print(f"Dose rate range: {dose_rate_10cm.min():.4e} - {dose_rate_10cm.max():.4e} uSv/h")
print(f"Binwidth used (log scale): {binwidth_log:.4f}")
print(f"Number of bins: {len(bins)-1}")

# Display the plot
plt.show()
