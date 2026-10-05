"""
Compile Figures for Upper Kuparuk River Basin, Alaska
Python equivalent of UK_figs_antecedent.mlx
"""

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

plt.rcParams.update({
    'font.family':        'serif',
    'mathtext.fontset':   'cm',
    'axes.labelsize':     18,
    'xtick.labelsize':    16,
    'ytick.labelsize':    16,
    'legend.fontsize':    14,
    'axes.linewidth':     1.2,
})

from antecedent_check import antecedent_check
from antecedent_check_runoff import antecedent_check_runoff


# ---------------------------------------------------------------------------
# Equivalent of figtRRD_plot_antecedent.m
# ---------------------------------------------------------------------------

def figtRRD_plot_antecedent(name, filename, filestats, workdir, workdirfig, printfig):
    """
    Returns
    -------
    maxRRD, maxRRDlgt, RRD, se, lagt, colNums, lagQrange
    """

    color_map = {
        4: np.array([[251,180,185],[247,104,161],[197,27,138],[122,1,119]]) / 255,
        5: np.array([[254,235,226],[251,180,185],[247,104,161],[197,27,138],[122,1,119]]) / 255,
        6: np.array([[254,235,226],[252,197,192],[250,159,181],[247,104,161],[197,27,138],[122,1,119]]) / 255,
        7: np.array([[254,235,226],[252,197,192],[250,159,181],[247,104,161],[221,52,151],[174,1,126],[122,1,119]]) / 255,
        8: np.array([[252,197,192],[212,185,218],[201,148,199],[250,159,181],[247,104,161],[221,52,151],[174,1,126],[122,1,119]]) / 255,
    }

    # --- Load peakstats ---
    peakstats = pd.read_csv(os.path.join(workdir, filestats), sep='\t')
    peakstats.columns = [c.strip() for c in peakstats.columns]
    # handle the "n.nz" / "nnz" column name variation
    peakstats.columns = [c.replace('n.nz', 'nnz') for c in peakstats.columns]

    colNums   = peakstats['mean_lagQ'].values
    lwr       = peakstats['lwr_lagQ'].values
    upr       = peakstats['upr_lagQ'].values
    lagQrange = np.append(lwr, upr[-1])   # lower bounds + final upper bound
    colRange  = lagQrange                 # used for legend text
    maxRRD    = peakstats['peakht'].values
    maxRRDse  = peakstats['peakht_se'].values
    maxRRDlgt = peakstats['tpeak'].values
    NOtests   = len(colNums)

    Colors = color_map[NOtests]

    # --- Load RRD timeseries ---
    rrd_dat  = pd.read_csv(os.path.join(workdir, filename), sep='\t')
    lagt     = rrd_dat.iloc[:, 0].values
    RRD      = rrd_dat.iloc[:, 1:NOtests + 1].values          # columns 1..NOtests
    se       = rrd_dat.iloc[:, NOtests + 1:2 * NOtests + 1].values  # columns NOtests+1..2*NOtests

    legend_texts = [
        f"{round(100*colRange[l])/100}-{round(100*colRange[l+1])/100} mm/h"
        for l in range(NOtests)
    ]

    # --- Figure 1: RRD lag-time curves ---
    fig1, ax1 = plt.subplots(figsize=(11, 7))
    for l in range(NOtests):
        ax1.errorbar(lagt, RRD[:, l], yerr=se[:, l],
                     color=Colors[l], linewidth=2.5, capsize=0)
    ax1.axhline(0, color='black', linestyle='--', linewidth=1.5)
    ax1.set_xlim([0, lagt.max()])
    ax1.set_ylim([0, (RRD + se).max()])
    ax1.set_xlabel('Lag time [h]')
    ax1.set_ylabel('RRD [1/h]')
    if name:
        ax1.set_title(name)
    ax1.legend(legend_texts, loc='upper right')
    ax1.ticklabel_format(axis='y', style='sci', scilimits=(-3, -3))
    fig1.tight_layout()

    if printfig:
        stem = filename.replace('1hr_simple_', '').replace('.txt', '')
        fig1.savefig(os.path.join(workdirfig, f'ltRRD_knots_{stem}2.png'), dpi=200)

    # --- Figure 2: Peak RRD vs antecedent Q ---
    fig2, ax2 = plt.subplots(figsize=(7, 7))
    # connecting line (bottom layer)
    ax2.plot(colNums, maxRRD, '-', color='k', linewidth=1.5, zorder=1)
    # large black background dots
    ax2.plot(colNums, maxRRD, '.', markersize=25, color='k', zorder=2)
    # error bars
    ax2.errorbar(colNums, maxRRD, yerr=maxRRDse[:NOtests],
                 fmt='none', ecolor='black', elinewidth=2.5,
                 capsize=0, zorder=3)
    # colored dots on top
    for jj in range(NOtests):
        ax2.plot(colNums[jj], maxRRD[jj], 'o', markersize=22,
                 color=Colors[jj], markeredgewidth=0, zorder=4)
    ax2.set_xlim([0, colNums.max() * 1.1])
    ax2.set_ylim([0, (maxRRD + maxRRDse).max()])
    ax2.set_xlabel('10-hour antecedent streamflow [mm/h]')
    ax2.set_ylabel('Peak RRD [1/h]')
    if name:
        ax2.set_title(name)
    ax2.ticklabel_format(axis='y', style='sci', scilimits=(-3, -3))
    fig2.tight_layout()

    if printfig:
        stem = filename.replace('1hr_simple_', '').replace('.txt', '')
        fig2.savefig(os.path.join(workdirfig, f'maxRRD_knot_{stem}2.png'), dpi=200)

    return maxRRD, maxRRDlgt, RRD, se, lagt, colNums, lagQrange


# ---------------------------------------------------------------------------
# Main — equivalent of the live script body
# ---------------------------------------------------------------------------

if __name__ == '__main__':

    workdir    = os.path.expanduser('~/Documents/GitHub/Permafrost_ERRA_Toolik_Bounty/datERRA/UK_antecedent')
    workdirfig = os.path.join(workdir, 'figures')
    printfig   = True

    os.makedirs(workdirfig, exist_ok=True)

    # Step 1: RRD lag-time figures; also extracts colNums and lagQrange
    maxRRD, maxRRDlgt, RRD, se, lagt, colNums, lagQrange = figtRRD_plot_antecedent(
        name='',
        filename='1hr_simple_RRD.txt',
        filestats='1hr_simple_peakstats.txt',
        workdir=workdir,
        workdirfig=workdirfig,
        printfig=printfig,
    )

    laghr = 10  # hours

    # Step 2: Precipitation distribution figures (all data)
    antecedent_check(workdir, workdirfig, printfig, laghr, colNums, lagQrange)

    # Step 3: Rainfall distribution figures (snow-free only)
    antecedent_check_runoff(workdir, workdirfig, printfig, laghr, colNums, lagQrange)

    plt.show()
