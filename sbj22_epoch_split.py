"""
Subject 22 (PD) ECoG — analysis split by the user-defined epochs in
data.trials.t1.epochs (e1..e33), each a [start,end] sample-index pair.

Uses the stored reference PSDs in data.trials.t1.psd.eN.saw (513xNch, 0-500 Hz)
and computes beta (13-30 Hz) and high-gamma (70-150 Hz) band power per epoch.
"""
import scipy.io as sio
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import csv

NAVY="#0B2545"; TEAL="#13A4A4"; AMBER="#E8A33D"
ch_colors=[NAVY,TEAL,AMBER,"#6C5B7B","#355C7D","#2E8B57"]
plt.rcParams.update({"font.family":"DejaVu Sans","font.size":9,
    "axes.edgecolor":NAVY,"axes.labelcolor":NAVY,"axes.titlecolor":NAVY,
    "xtick.color":NAVY,"ytick.color":NAVY})

m = sio.loadmat("/Users/terry/Documents/22data.mat",
                struct_as_record=False, squeeze_me=True)
d=m["data"]; Fs=int(d.cfg.info.Fs)
t1=d.trials.t1
ecog=np.asarray(t1.sig.ecog)
N,nch=ecog.shape

# ---- epoch boundaries ----
epnames=t1.epochs._fieldnames
bounds=[]
for nm in epnames:
    a=np.array(getattr(t1.epochs,nm)).ravel().astype(int)
    bounds.append((nm,a[0],a[1]))
n_ep=len(bounds)

# ---- stored reference PSDs ----
freq=np.array(t1.psd.freq)
psd=np.zeros((n_ep,len(freq),nch))
for i,(nm,_,_) in enumerate(bounds):
    psd[i]=np.array(getattr(t1.psd,nm).saw)

# ---- band power per epoch (integrate stored PSD) ----
def band_power(lo,hi,exclude_harmonics=False):
    mask=(freq>=lo)&(freq<=hi)
    if exclude_harmonics:
        for h in np.arange(60,hi+1,60):
            mask &= ~((freq>=h-2)&(freq<=h+2))
    # (n_ep, nch)
    return np.trapezoid(psd[:,mask,:],freq[mask],axis=1)

beta = band_power(13,30)                       # (n_ep, nch)
gamma= band_power(70,150,exclude_harmonics=True)
dur_s=np.array([(b[2]-b[1])/Fs for b in bounds])
mid_s=np.array([(b[1]+b[2])/2/Fs for b in bounds])

# ---- write per-epoch table ----
out_csv="/Users/terry/Documents/sbj22_epoch_split_bandpower.csv"
with open(out_csv,"w",newline="") as fh:
    w=csv.writer(fh)
    hdr=["epoch","start_sample","end_sample","dur_s"]
    hdr+=[f"beta_ECoG{c+1}_V2" for c in range(nch)]+["beta_mean"]
    hdr+=[f"gamma_ECoG{c+1}_V2" for c in range(nch)]+["gamma_mean"]
    w.writerow(hdr)
    for i,(nm,s,e) in enumerate(bounds):
        row=[nm,s,e,round(dur_s[i],3)]
        row+=[f"{beta[i,c]:.6e}" for c in range(nch)]+[f"{beta[i].mean():.6e}"]
        row+=[f"{gamma[i,c]:.6e}" for c in range(nch)]+[f"{gamma[i].mean():.6e}"]
        w.writerow(row)

# ================= FIGURE 1: overview split by epochs =================
fig=plt.figure(figsize=(13,9))
gs=fig.add_gridspec(3,1,height_ratios=[1.1,1,1],hspace=0.38,
                    left=0.07,right=0.97,top=0.91,bottom=0.07)
fig.suptitle(f"Subject 22 (PD) · split by {n_ep} defined epochs "
            f"(variable length, {dur_s.sum():.0f}s total)",
            fontsize=13,fontweight="bold",color=NAVY,y=0.965)

# Panel A: raw (ch-mean) full recording with epoch spans shaded
axA=fig.add_subplot(gs[0])
t=np.arange(0,N,50)/Fs                       # decimate for display
axA.plot(t,ecog[::50,:].mean(1),color=NAVY,lw=0.3)
for i,(nm,s,e) in enumerate(bounds):
    axA.axvspan(s/Fs,e/Fs,color=AMBER,alpha=0.18,lw=0)
axA.set_xlim(0,N/Fs); axA.set_xlabel("Time (s)")
axA.set_ylabel("ch-mean ECoG (V)")
axA.set_title(f"A · Recording with the {n_ep} epochs shaded",
              loc="left",fontweight="bold")
for sp in ["top","right"]: axA.spines[sp].set_visible(False)

# Panel B: stored PSD per epoch (ch-averaged), overlaid
axB=fig.add_subplot(gs[1])
cmap=plt.cm.viridis(np.linspace(0,1,n_ep))
for i in range(n_ep):
    axB.semilogy(freq,psd[i].mean(1),color=cmap[i],lw=0.6,alpha=0.8)
for nm,lo,hi,col in [("β",13,30,AMBER),("γ",70,150,TEAL)]:
    axB.axvspan(lo,hi,color=col,alpha=0.10,lw=0)
    axB.text((lo+hi)/2,axB.get_ylim()[1],nm,ha="center",va="bottom",
            fontsize=9,color=NAVY)
axB.set_xlim(0,160); axB.set_xlabel("Frequency (Hz)")
axB.set_ylabel("PSD (V²/Hz)")
axB.set_title("B · Stored PSD per epoch (channel-averaged, colored e1→eN)",
              loc="left",fontweight="bold")
sm=plt.cm.ScalarMappable(cmap="viridis",
    norm=plt.Normalize(1,n_ep)); sm.set_array([])
cb=fig.colorbar(sm,ax=axB,pad=0.01); cb.set_label("epoch #")
for sp in ["top","right"]: axB.spines[sp].set_visible(False)

# Panel C: beta & gamma band power per epoch
axC=fig.add_subplot(gs[2])
x=np.arange(n_ep)
axC.bar(x-0.2,beta.mean(1)*1e12,width=0.4,color=AMBER,label="β (13–30 Hz)")
axC.set_ylabel("Beta power (pV²)",color=AMBER)
axC.tick_params(axis="y",labelcolor=AMBER)
axC2=axC.twinx()
axC2.bar(x+0.2,gamma.mean(1)*1e12,width=0.4,color=TEAL,label="γ (70–150 Hz)")
axC2.set_ylabel("Gamma power (pV²)",color=TEAL)
axC2.tick_params(axis="y",labelcolor=TEAL)
axC.set_xticks(x); axC.set_xticklabels([b[0] for b in bounds],
    rotation=90,fontsize=6)
axC.set_xlabel("Epoch")
axC.set_title("C · Channel-averaged band power per epoch "
              "(β left axis, γ right axis)",loc="left",fontweight="bold")
for sp in ["top"]: axC.spines[sp].set_visible(False); axC2.spines[sp].set_visible(False)

fig.savefig("/Users/terry/Documents/sbj22_epoch_split_overview.png",dpi=200,
            facecolor="white",bbox_inches="tight")
print("saved overview")

# ================= FIGURE 2: PSD-by-epoch heatmap (spectrogram-like) =================
fig2,(ax1,ax2)=plt.subplots(2,1,figsize=(13,8),height_ratios=[1.4,1],
                            gridspec_kw=dict(hspace=0.32))
fmask=freq<=160
P=10*np.log10(psd[:,fmask,:].mean(2)).T     # (nfreq, n_ep)
im=ax1.pcolormesh(np.arange(n_ep),freq[fmask],P,shading="auto",cmap="magma")
ax1.set_ylabel("Frequency (Hz)"); ax1.set_xlabel("Epoch index")
ax1.set_xticks(np.arange(n_ep)); ax1.set_xticklabels([b[0] for b in bounds],
    rotation=90,fontsize=6)
ax1.axhline(13,color="w",lw=0.4,ls=":"); ax1.axhline(30,color="w",lw=0.4,ls=":")
ax1.axhline(70,color="c",lw=0.4,ls=":"); ax1.axhline(150,color="c",lw=0.4,ls=":")
ax1.set_title("A · Stored PSD across epochs (channel-averaged, dB)",
              loc="left",fontweight="bold",color=NAVY)
cb=fig2.colorbar(im,ax=ax1,pad=0.01); cb.set_label("Power (dB)")

ax2.plot(x,beta.mean(1)*1e12,"-o",color=AMBER,ms=3,label="β (13–30 Hz)")
ax2b=ax2.twinx()
ax2b.plot(x,gamma.mean(1)*1e12,"-s",color=TEAL,ms=3,label="γ (70–150 Hz)")
ax2.set_ylabel("Beta (pV²)",color=AMBER); ax2.tick_params(axis="y",labelcolor=AMBER)
ax2b.set_ylabel("Gamma (pV²)",color=TEAL); ax2b.tick_params(axis="y",labelcolor=TEAL)
ax2.set_xticks(x); ax2.set_xticklabels([b[0] for b in bounds],rotation=90,fontsize=6)
ax2.set_xlabel("Epoch"); ax2.set_xlim(-0.5,n_ep-0.5)
ax2.set_title("B · Band-power trajectory across epochs",loc="left",
              fontweight="bold",color=NAVY)
for sp in ["top"]: ax2.spines[sp].set_visible(False); ax2b.spines[sp].set_visible(False)
fig2.suptitle(f"Subject 22 (PD) · band power across {n_ep} defined epochs",
            fontsize=12,fontweight="bold",color=NAVY)
fig2.savefig("/Users/terry/Documents/sbj22_epoch_split_heatmap.png",dpi=200,
            facecolor="white",bbox_inches="tight")
print("saved heatmap")

# ---- console summary ----
print(f"\n{n_ep} epochs, durations {dur_s.min():.0f}-{dur_s.max():.0f}s")
print("Grand mean beta : %.4e V^2"%beta.mean())
print("Grand mean gamma: %.4e V^2"%gamma.mean())
print("\nTop-3 beta epochs:", [bounds[i][0] for i in np.argsort(-beta.mean(1))[:3]])
print("Top-3 gamma epochs:",[bounds[i][0] for i in np.argsort(-gamma.mean(1))[:3]])
print("table:",out_csv)
