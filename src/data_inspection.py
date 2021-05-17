import pandas as pd
import numpy as np

from gameStopStockPrediction.src.own_metrics_and_other_utils import compute_average_change_per_timestep

df = pd.read_csv("../input/GME_04Jan_12May.csv")
print("Number of rows and colums:", df.shape)
df.head(5)
train_threshold = 60
batch_size = 15

all_close_values = df.iloc[:, 4:5].values
np.std(all_close_values)
np.mean(all_close_values)

test_close_values = df.iloc[train_threshold - batch_size:, 4:5].values

test_average_change = compute_average_change_per_timestep(test_close_values)
