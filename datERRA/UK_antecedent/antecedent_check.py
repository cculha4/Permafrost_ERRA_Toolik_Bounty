import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.stats import gaussian_kde

plt.rcParams.update({
    'font.family':        'serif',
    'mathtext.fontset':   'cm',
    'axes.labelsize':     18,
    'xtick.labelsize':    16,
    'ytick.labelsize':    16,
    'legend.fontsize':    14,
    'axes.linewidth':     1.2,
})


def antecedent_check(workdir, workdirfig, printfig, laghr, colNums, lagQrange):
    colNums = np.asarray(colNums)
    Qranges = np.asarray(lagQrange)
    NOtestsp = len(colNums)

    color_map = {
        3: np.array([[251,180,185],[197,27,138],[122,1,119]]) / 255,
        4: np.array([[251,180,185],[247,104,161],[197,27,138],[122,1,119]]) / 255,
        5: np.array([[254,235,226],[251,180,185],[247,104,161],[197,27,138],[122,1,119]]) / 255,
        6: np.array([[254,235,226],[252,197,192],[250,159,181],[247,104,161],[197,27,138],[122,1,119]]) / 255,
        7: np.array([[254,235,226],[252,197,192],[250,159,181],[247,104,161],[221,52,151],[174,1,126],[122,1,119]]) / 255,
        8: np.array([[255,247,243],[253,224,221],[252,197,192],[250,159,181],[247,104,161],[221,52,151],[174,1,126],[122,1,119]]) / 255,
    }
    Colors = color_map[NOtestsp]

    dat = pd.read_csv(os.path.join(workdir, '1hr_simple_Qcomp.txt'), sep='\t')
    P = dat['P'].values
    Q = dat['Q'].values
    sizes = len(P)

    P_med = np.full(NOtestsp, np.nan)
    P_std = np.full(NOtestsp, np.nan)

    # --- Figure 1: Histograms + KDE per Q bin ---
    fig1, axes = plt.subplots(NOtestsp, 1, figsize=(9, 2.5 * NOtestsp))
    if NOtestsp == 1:
        axes = [axes]

    for l in range(NOtestsp):
        ax = axes[NOtestsp - l - 1]  # bottom subplot = lowest Q range, matching Matlab order
        idx = np.where((Q > Qranges[l]) & (Q <= Qranges[l + 1]))[0]
        idx = idx[idx + laghr < sizes]
        dataP = P[idx + laghr]

        if len(dataP) > 1:
            ax.hist(dataP, bins=20, density=False,
                    weights=np.ones(len(dataP)) / len(dataP), alpha=0.7)
            kde = gaussian_kde(dataP[np.isfinite(dataP)])
            x_vals = np.linspace(0, 3, 300)
            ax.plot(x_vals, kde(x_vals))

        P_med[l] = np.nanmean(dataP)
        P_std[l] = np.nanstd(dataP)
        ax.set_xlim([0, 3])
        ax.set_ylim([0, 1])
        ax.text(1.75, 0.5, f"{Qranges[l]}-{Qranges[l+1]} Antec. Q", fontsize=10)

        if l > 0:
            ax.set_xticklabels([])
        if l == 0:
            ax.set_xlabel('Precipitation [mm/hr]')

    fig1.tight_layout()
    if printfig:
        fig1.savefig(os.path.join(workdirfig, f'Pdisp_4_each{laghr}hrQ_lag2.png'), dpi=200)

    # --- Figure 2: CDF with log y-axis ---
    fig2, ax2 = plt.subplots(figsize=(9, 7))
    legend_texts = []

    for l in range(NOtestsp):
        idx = np.where((Q > Qranges[l]) & (Q <= Qranges[l + 1]))[0]
        idx = idx[idx + laghr < sizes]
        dataP = P[idx + laghr]
        dataP = dataP[np.isfinite(dataP)]

        sorted_data = np.sort(dataP)
        cdf = np.arange(1, len(sorted_data) + 1) / len(sorted_data)
        ax2.plot(sorted_data, cdf, color=Colors[l], linewidth=2.5)
        legend_texts.append(
            f"{round(100*Qranges[l])/100}-{round(100*Qranges[l+1])/100} mm/hr"
        )

    ax2.set_yscale('log')
    ax2.set_xlim([0, 4])
    ax2.set_ylim([1e-3, 1])
    ax2.legend(legend_texts, loc='upper left')
    ax2.set_xlabel('Rainfall [mm/hr]')
    ax2.set_ylabel('Log Cumulative Distribution Function')

    if printfig:
        fig2.savefig(os.path.join(workdirfig, f'CDF_Pdisp_4_each{laghr}hrQ_lag2.png'), dpi=200)

    # --- Figure 3: Error bar of mean P per Q bin ---
    fig3, ax3 = plt.subplots(figsize=(9, 7))
    ax3.errorbar(colNums, P_med, yerr=P_std, fmt='ok', markersize=10,
                 markeredgecolor='black')
    ax3.set_title('Average Precipitation Intensity for\neach 6-hour lag in Antecedent Runoff')
    ax3.set_xlabel('Antecedent Q [mm/hr]')
    ax3.set_ylabel('Av. Precipitation [mm/hr]')

    if printfig:
        fig3.savefig(os.path.join(workdirfig, f'meanP_4_each{laghr}hrQ_lag.png'), dpi=200)

    # --- Figure 4: Box plot of P grouped by Q bin ---
    fig4, ax4 = plt.subplots(figsize=(9, 7))
    boxplot_data = []
    box_labels = []

    for l in range(NOtestsp):
        idx = np.where((Q > Qranges[l]) & (Q <= Qranges[l + 1]))[0]
        idx = idx[idx + laghr < sizes]
        dataP = P[idx + laghr]
        boxplot_data.append(dataP[np.isfinite(dataP)])
        box_labels.append(colNums[l])

    ax4.boxplot(boxplot_data, labels=box_labels)
    ax4.set_title('Average Precipitation Intensity for\neach 6-hour lag in Antecedent Streamflow')
    ax4.set_xlabel('Antecedent Q [mm/hr]')
    ax4.set_ylabel('Av. Precipitation [mm/hr]')

    if printfig:
        fig4.savefig(os.path.join(workdirfig, f'meanP_boxPlot{laghr}hrQ_lag.png'), dpi=200)

    plt.show()


if __name__ == '__main__':
    workdir    = '/Users/cansu/Documents/GitHub/Permafrost_ERRA_Toolik_Bounty/datERRA/UK_antecedent'
    workdirfig = '/Users/cansu/Documents/GitHub/Permafrost_ERRA_Toolik_Bounty/datERRA/UK_antecedent/figures'
    printfig   = False
    laghr      = 6
    colNums    = [0.1, 0.3, 0.6, 1.0]
    lagQrange  = [0.0, 0.1, 0.3, 0.6, 1.0, 9999]

    antecedent_check(workdir, workdirfig, printfig, laghr, colNums, lagQrange)
