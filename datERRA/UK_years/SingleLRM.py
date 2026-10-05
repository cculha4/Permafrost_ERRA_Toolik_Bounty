"""
SingleLRM — Python equivalent of the SingleLRM block in
UK_compilefigs_years_StatModels.mlx

Produces a 6×2 panel of simple linear regressions between each
climate/hydrology predictor and peak RRD, color-coded by year.
"""

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import scipy.io as sio
from scipy import stats

# ---------------------------------------------------------------------------
# Global style (matching Matlab LaTeX interpreter)
# ---------------------------------------------------------------------------
plt.rcParams.update({
    'font.family':      'serif',
    'mathtext.fontset': 'cm',
    'axes.labelsize':   14,
    'xtick.labelsize':  12,
    'ytick.labelsize':  12,
    'legend.fontsize':  10,
    'axes.linewidth':   1.0,
})

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
WORKDIR    = os.path.dirname(os.path.abspath(__file__))
RRESULTS   = os.path.join(WORKDIR, 'Rresults')
WORKDIRFIG = os.path.join(WORKDIR, 'figures')
os.makedirs(WORKDIRFIG, exist_ok=True)

# ---------------------------------------------------------------------------
# Color palette (13 colors for years 2005–2017, matching yearsplots.m)
# Index maps to year: 0→2005, 1→2006, 2→2007, …, 12→2017
# ---------------------------------------------------------------------------
ALL_COLORS = np.array([
    [203, 201, 226],  # 2005
    [158, 154, 200],  # 2006
    [106,  81, 163],  # 2007
    [186, 228, 179],  # 2008
    [116, 196, 118],  # 2009
    [ 35, 139,  69],  # 2010
    [253, 190, 133],  # 2011
    [253, 141,  60],  # 2012
    [217,  71,   1],  # 2013
    [189, 215, 231],  # 2014
    [107, 174, 214],  # 2015
    [ 33, 113, 181],  # 2016
    [ 28, 144, 153],  # 2017
], dtype=float) / 255

ALL_YEARS = list(range(2005, 2018))   # 2005–2017 inclusive

# ---------------------------------------------------------------------------
# Load pre-compiled variable parameters from .mat file
# ---------------------------------------------------------------------------
mat = sio.loadmat(os.path.join(WORKDIR, 'Considered_VarParameters.mat'))

years_data = mat['years'].flatten().astype(int)   # e.g. [2005,2007,…,2017]
maxRRD     = mat['maxRRD'].flatten()

# Assign a color to each data year by its position in ALL_YEARS
year_colors = np.array([ALL_COLORS[ALL_YEARS.index(y)] for y in years_data])

# VarParameters: shape (12 predictors × 12 years)
VP = mat['VarParameters']   # rows = predictors, cols = years

# ---------------------------------------------------------------------------
# Predictor names (matching the image labels)
# ---------------------------------------------------------------------------
VAR_NAMES = [
    'Total Summer Precip [mm/3 mo]',
    'Total Summer Rainfall [mm/3 mo]',
    'Average Rainfall\nIntensity [mm/d]',
    'Win & Sprg Temp [°C]',
    'Average Rainfall Intensity\nPrev Summer [mm/d]',
    'Total Snow Precip [mm/3 mo]',
    'Total Rainfall\nPrev Summer [mm/3 mo]',
    'Sum Temperature > 0°C [°C d]',
    'Summer Temp [°C]',
    'Max Sprg Q [mm/d]',
    'Max Ann Snow Thickness [cm]',
    'Rate of Thawing [cm/d]',
]

# ---------------------------------------------------------------------------
# Compute maxRRDse from per-year RRD files
# (se at the lag time where RRD is maximum)
# ---------------------------------------------------------------------------
maxRRDse = np.full(len(years_data), np.nan)
for i, yr in enumerate(years_data):
    fpath = os.path.join(RRESULTS, f'1hr_simple_{yr}_RRD.txt')
    if not os.path.exists(fpath):
        continue
    df   = pd.read_csv(fpath, sep='\t')
    rrd  = df.iloc[:, 1].values
    se   = df.iloc[:, 2].values
    idx  = np.nanargmax(rrd)
    maxRRDse[i] = se[idx]

# ---------------------------------------------------------------------------
# Build the SingleLRM figure
# ---------------------------------------------------------------------------
fig, axes = plt.subplots(6, 2, figsize=(11, 11))
axes = axes.flatten()

for l, ax in enumerate(axes):
    x = VP[l, :]
    y = maxRRD

    # mask NaNs
    mask = np.isfinite(x) & np.isfinite(y)
    x_ok = x[mask]
    y_ok = y[mask]
    se_ok = maxRRDse[mask]
    cols_ok = year_colors[mask]

    # --- error bars (black, no marker) ---
    for xi, yi, si in zip(x_ok, y_ok, se_ok):
        if np.isfinite(si):
            ax.errorbar(xi, yi, yerr=si, fmt='none',
                        ecolor='black', elinewidth=1.0, capsize=0, zorder=2)

    # --- colored dots ---
    for xi, yi, ci in zip(x_ok, y_ok, cols_ok):
        ax.plot(xi, yi, '.', markersize=12, color=ci, zorder=3)

    # --- linear fit ---
    if len(x_ok) >= 2:
        slope, intercept, r_val, p_val, _ = stats.linregress(x_ok, y_ok)
        significant = p_val < 0.05
        if significant:
            x_fit = np.linspace(x_ok.min(), x_ok.max(), 200)
            ax.plot(x_fit, slope * x_fit + intercept, 'r-', linewidth=2, zorder=1)
        # format p: show as < 0.001 if tiny, else 2 sig figs
        if p_val < 0.001:
            p_str = '$p < 0.001$'
        else:
            p_str = f'$p = {p_val:.2f}$'
        label = f'$r = {r_val:.2f}$\n{p_str}'
    else:
        label = '$r = $ N/A'

    # --- r and p text ---
    ax.text(0.05, 0.95, label,
            transform=ax.transAxes,
            ha='left', va='top',
            fontsize=14,
            fontfamily='serif',
            linespacing=1.5)

    # --- axis labels ---
    ax.set_xlabel(VAR_NAMES[l], labelpad=3)
    ax.ticklabel_format(axis='y', style='sci', scilimits=(-3, -3))

    # y-limit with 50% headroom for the r text
    ymax = (y_ok + np.where(np.isfinite(se_ok), se_ok, 0)).max()
    ax.set_ylim([0, ymax * 1])
    ax.set_xlim([x_ok.min() - 0.04 * (x_ok.max() - x_ok.min()),
                 x_ok.max() + 0.04 * (x_ok.max() - x_ok.min())])

fig.suptitle('')

# ---------------------------------------------------------------------------
# Year legend — right side, one patch per year (2005–2017)
# ---------------------------------------------------------------------------
legend_handles = [
    mpatches.Patch(color=ALL_COLORS[i], label=str(yr))
    for i, yr in enumerate(ALL_YEARS)
]
fig.legend(
    handles=legend_handles,
    loc='center right',
    bbox_to_anchor=(1.0, 0.5),
    frameon=False,
    fontsize=8,
    handlelength=1.0,
    handleheight=1.0,
    borderpad=0.3,
)

fig.tight_layout(rect=[0, 0, 0.88, 1])   # leave room for legend
fig.subplots_adjust(hspace=0.75)

# ---------------------------------------------------------------------------
# Save
# ---------------------------------------------------------------------------
out_path = os.path.join(WORKDIRFIG, 'SingleLRM.png')
fig.savefig(out_path, dpi=300, bbox_inches='tight')
print(f'Saved → {out_path}')
plt.show()
