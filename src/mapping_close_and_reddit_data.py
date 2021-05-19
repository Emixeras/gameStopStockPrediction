import pandas as pd

close_data = pd.read_csv("../input/GME_04Jan_11May.csv")
reddit_data = pd.read_csv("../input/GME_quantity_reddit_posts_jan_may14.csv")

merged_data = (close_data.merge(reddit_data, left_on="Date", right_on="Datum").reindex(columns=["Date", "Close", "Anzahl"]))


