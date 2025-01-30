import pandas as pd  


# df = pd.read_csv('./data/vgsales.csv')
# print(df.dtypes)

df = pd.read_parquet('./data/vgsales.parquet')
print(df.head(5))
print(df.dtypes)



