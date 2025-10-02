import matplotlib.pyplot as plt
import pandas as pd

# データ
data = {
    "duration_sec": [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5],
    "avg_sec": [0.00177, 0.08329, 0.18326, 0.28340, 0.38333, 0.48330, 0.58328, 0.68339, 0.78354, 0.88363, 0.98341, 1.08359, 1.18308, 1.28311, 1.38335, 1.48342],
    "detection_rate": [0.001625568949,0.06973486743,0.1706841368,0.2781056211, 0.3817645294, 0.4779889945, 0.575865173, 0.6587476243, 0.7434960977, 0.8446723362, 0.90625, 0.9554777389, 0.9794897449, 0.9929964982, 0.9979969955, 0.9985]
}

df = pd.DataFrame(data)

# グラフ作成
fig, ax1 = plt.subplots(figsize=(7, 4))

# detection rate (右軸, 点のみ)
ax2 = ax1.twinx()
ax2.scatter(df["duration_sec"], df["detection_rate"], marker="o", color="tab:orange", label="Detection Rate")
ax2.set_ylabel("Detection Rate", color="tab:orange", fontsize=12)
ax2.tick_params(axis='y', labelcolor="tab:orange")

# 平均セッション時間 (左軸, 点のみ)
ax1.scatter(df["duration_sec"], df["avg_sec"], marker="s", color="tab:blue", label="Average Session Duration [s]")
ax1.set_xlabel("Configured Duration [s]", fontsize=12)
ax1.set_ylabel("Average Session Duration [s]", color="tab:blue", fontsize=12)
ax1.tick_params(axis='y', labelcolor="tab:blue")

# タイトルと凡例
# fig.suptitle("TLS Session Duration vs Detection Rate", fontsize=14)
ax1.legend(loc="lower center", fontsize=12)
ax2.legend(loc="upper center", fontsize=12)

# ax1.legend(loc="best", fontsize=12)
# ax2.legend(loc="best", fontsize=12)


plt.grid(True)
plt.tight_layout()
plt.show()
