import math
import matplotlib.pyplot as plt
import keras
import pandas as pd
import numpy as np

df = pd.read_csv("../input/GME.csv")
print("Number of rows and colums:", df.shape)
df.head(5)


