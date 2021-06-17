import datetime

df = pd.DataFrame(comments_df)
df = df[['author', 'body', 'created_utc']] #overwrite df and keep just named variables
df.head(5)

df["timestamp"] = pd.to_datetime(df["created_utc"], unit="s") #get the timestamp
df["just_date"] = df["timestamp"].dt.date 
df.head(5)

counter = df.groupby("just_date").size().rename("Count") #count comments per day

result = df.drop_duplicates(subset='just_date')\
    .merge(counter, left_on='just_date', right_index=True) #keep one comment for every day
result = result[['just_date', 'Count']] #keep the variable 'just date' and 'Count'
result