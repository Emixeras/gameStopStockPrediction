import pandas as pd
import numpy as np

from gameStopStockPrediction.src.own_metrics_and_other_utils import compute_average_change_per_timestep


#read in csv
df = pd.read_csv("../input/GME_04Jan_11May.csv")
print("Number of rows and colums:", df.shape)
df.head(5)
train_threshold = 60
batch_size = 15

# compute mean and standard deviation
all_close_values = df.iloc[:, 4:5].values
np.std(all_close_values)
np.mean(all_close_values)

# compute average change per timestep
test_close_values = df.iloc[train_threshold - batch_size:, 4:5].values

test_average_change = compute_average_change_per_timestep(test_close_values)

# compute median reddit comments
df = pd.read_csv("../input/reddit_comments_Jan01_May19_polished_median.csv")

np.median(df["Anzahl"])

