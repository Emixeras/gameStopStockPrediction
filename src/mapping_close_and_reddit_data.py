import pandas as pd

close_data = pd.read_csv("../input/GME_04Jan_11May.csv")
reddit_data = pd.read_csv("../input/reddit_comments_Jan01_May19_polished.csv")

merged_data = (close_data.merge(reddit_data, left_on="Date", right_on="Datum").reindex(columns=["Date", "Close", "Anzahl"]))

merged_data.to_csv("../input/GME_CloseAndReddit_04Jan_11May.csv")
