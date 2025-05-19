import pandas as pd
import numpy as np

df = pd.read_csv('Updatefile Sales.csv')
# print(df.head())

#Inventory Days = Average Inventory *365 / Cost of sold goods
#Inventory Days = unitssold / average units sold by day

#Define a simple proxy:
#inventory_days
df['inventory_days'] = df['unitssold']

#profit_margin
df['profit_margin'] = (df['profit'] / df['sales'])

#Ensure no division errors
df = df.replace([float('inf'), -float('inf')], 0).dropna(subset=['profit_margin'])


correlation = df['inventory_days'].corr(df['profit_margin'])
print(f'Correlation between inventory days and profit margin: {correlation}')