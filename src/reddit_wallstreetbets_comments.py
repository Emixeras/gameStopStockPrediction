import pandas as pd
from pmaw import PushshiftAPI


api = PushshiftAPI()


import datetime as dt
before = int(dt.datetime(2021,5,20,0,0).timestamp())
after = int(dt.datetime(2021,1,1,0,0).timestamp())



subreddit="wallstreetbets"
query = ["Gamestop | GME"]
limit=10000000
comments = api.search_comments(q = query, subreddit=subreddit, limit=limit, before=before, after=after)
print(f'Retrieved {len(comments)} comments from Pushshift')

comments_df = pd.DataFrame(comments)# preview the comments data
comments_df.head(5)

comments_df.to_csv('./wsb_comments.csv', header=True, index=False, columns=list(comments_df.axes[1]))