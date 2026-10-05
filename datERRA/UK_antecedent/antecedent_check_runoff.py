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

SYNTHESIZED_DATA = '/Users/cansu/Documents/GitHub/Permafrost_ERRA/datERRA/UK/UK_synthesized_data.txt'


def antecedent_check_runoff(workdir, workdirfig, printfig, laghr, colNums, lagQrange):
    colNums = np.asarray(colNums)
    Qranges = np.asarray(lagQrange)
    xvalues = colNums
    NOtestsp = len(xvalues)

    color_map = {
        3: np.array([[251,180,185],[197,27,138],[122,1,119]]) / 255,
        4: np.array([[251,180,185],[247,104,161],[197,27,138],[122,1,119]]) / 255,
        5: np.array([[254,235,226],[251,180,185],[247,104,161],[197,27,138],[122,1,119]]) / 255,
        6: np.array([[254,235,226],[252,197,192],[250,159,181],[247,104,161],[197,27,138],[122,1,119]]) / 255,
        7: np.array([[254,235,226],[252,197,192],[250,159,181],[247,104,161],[221,52,151],[174,1,126],[122,1,119]]) / 255,
        8: np.array([[255,247,243],[253,224,221],[252,197,192],[250,159,181],[247,104,161],[221,52,151],[174,1,126],[122,1,119]]) / 255,
    }
    Colors = color_map[NOtestsp]

    dat = pd.read_csv(SYNTHESIZED_DATA)
    Q = dat['Q'].values
    P = dat['P'].values
    Temp = dat['airtemp'].values
    months = dat['months'].values

    # Snow-free filter: months May–Oct (5–10), air temp > 2 °C
    snowfree = (months > 4) & (months < 11) & (Temp > 2)

    P_snowfree = P[snowfree]
    Q_snowfree = Q[snowfree]
    sizes = len(P)

    P_med = np.full(NOtestsp, np.nan)
    P_std = np.full(NOtestsp, np.nan)

    # --- Figure 1: Histograms + KDE per Q bin (snow-free only) ---
    fig1, axes = plt.subplots(NOtestsp, 1, figsize=(9, 2.5 * NOtestsp))
    if NOtestsp == 1:
        axes = [axes]

    for l in range(NOtestsp):
        ax = axes[NOtestsp - l - 1]
        idx = np.where((Q > Qranges[l]) & (Q <= Qranges[l + 1]) & snowfree)[0]
        idx = idx[idx + laghr < sizes]
        dataP = P[idx + laghr]

        if len(dataP) > 1:
            ax.hist(dataP, bins=20, density=False,
                    weights=np.ones(len(dataP)) / len(dataP), alpha=0.7)
            finite_data = dataP[np.isfinite(dataP)]
            if len(finite_data) > 1:
                kde = gaussian_kde(finite_data)
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
            ax.set_xlabel('Rainfall [mm/hr]')

    fig1.tight_layout()
    if printfig:
        fig1.savefig(
            os.path.join(workdirfig, f'Pdisp_4_each{laghr}hrQ_lag2_rainfall.png'), dpi=200
        )

    # --- Figure 2: Mean rainfall vs log(Q) with color-coded dots + error bars ---
    fig2, ax2 = plt.subplots(figsize=(7, 7))

    log_x = np.log10(xvalues)
    ax2.plot(log_x, P_med, '.', markersize=25, color='k')
    ax2.errorbar(log_x, P_med, yerr=P_std, fmt='ok', linestyle='none',
                 markersize=10, markeredgecolor='black')
    for jj in range(NOtestsp):
        ax2.plot(log_x[jj], P_med[jj], '.', markersize=22, color=Colors[jj])

    ax2.set_title('Average Rainfall Intensity for\neach 6-hour lag in Antecedent Runoff')
    ax2.set_xlabel('Log Antecedent Q [mm/hr]')
    ax2.set_ylabel('Av. Rainfall [mm/hr]')
    ax2.set_ylim([0, 0.6])

    if printfig:
        fig2.savefig(
            os.path.join(workdirfig, f'meanP_4_each{laghr}hrQ_lag_rainfall.png'), dpi=200
        )

    plt.show()


if __name__ == '__main__':
    workdir    = '/Users/cansu/Documents/GitHub/Permafrost_ERRA_Toolik_Bounty/datERRA/UK_antecedent'
    workdirfig = '/Users/cansu/Documents/GitHub/Permafrost_ERRA_Toolik_Bounty/datERRA/UK_antecedent/figures'
    printfig   = False
    laghr      = 6
    colNums    = [0.1, 0.3, 0.6, 1.0]
    lagQrange  = [0.0, 0.1, 0.3, 0.6, 1.0, 9999]

    antecedent_check_runoff(workdir, workdirfig, printfig, laghr, colNums, lagQrange)
