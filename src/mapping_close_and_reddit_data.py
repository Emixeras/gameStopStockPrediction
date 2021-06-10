import pandas as pd

"""
maps reddit comments date to close value dates and saves them in one csv
"""

close_data = pd.read_csv("../input/GME_04Jan_11May.csv")
reddit_data = pd.read_csv("../input/reddit_comments_Jan01_May19_polished_previous_value.csv")

merged_data = (close_data.merge(reddit_data, left_on="Date", right_on="Datum").reindex(columns=["Date", "Close", "Anzahl"]))

merged_data.to_csv("../input/GME_CloseAndReddit_previous_polish_04Jan_11May.csv")
