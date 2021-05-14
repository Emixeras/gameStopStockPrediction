import math
import matplotlib.pyplot as plt
import keras
import pandas as pd
import numpy as np

df = pd.read_csv("../input/GME.csv")
print("Number of rows and colums:", df.shape)
df.head(5)
train_threshold = 60
batch_size = 10

all_close_values = df.iloc[:, 4:5].values
np.std(all_close_values)
np.mean(all_close_values)

test_close_values = df.iloc[train_threshold - batch_size:, 4:5].values


def compute_average_change_per_timestep(data):
    sum = 0
    for i in range(1, len(data)):
        sum += np.sqrt((data[i, 0] - data[i - 1, 0]) ** 2)
    sum = sum / (len(data) - 1)
    return sum


test_average_change = compute_average_change_per_timestep(test_close_values)
