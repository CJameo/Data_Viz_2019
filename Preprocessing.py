import numpy as np
import pandas as pd
import math

# organizing data from 2018
month_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
               "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
dataset = pd.DataFrame()
for filenum in range(1, 13):
    data = pd.read_csv('original_data\{}.csv'.format(filenum),
                       header=0, delimiter=',',
                       quotechar='"', decimal='.',
                       lineterminator='\n')
    data = data.dropna(subset=['CARRIER_DELAY'])

    united = data[data.OP_UNIQUE_CARRIER == "UA"]
    american = data[data.OP_UNIQUE_CARRIER == "AA"]
    southwest = data[data.OP_UNIQUE_CARRIER == "WN"]
    delta = data[data.OP_UNIQUE_CARRIER == "DL"]

    major = pd.concat([united, american, southwest, delta], axis=0)

    month = major.drop(['CANCELLATION_CODE'], axis=1)

    dataset = pd.concat([dataset, month], axis=0)

    pd.DataFrame.to_csv(month, "complete_data\{}_complete.csv".format(month_names[filenum-1]))

dataset = dataset.drop(columns='Unnamed: 37')
dataset = dataset.drop(columns='YEAR')
pd.DataFrame.to_csv(dataset, "complete_data\dataset_complete.csv", index=False)

# creating trimmed versions (random sample)
dataset = pd.DataFrame()
for filenum in range(1, 13):
    data = pd.read_csv('original_data\{}.csv'.format(filenum),
                       header=0, delimiter=',',
                       quotechar='"', decimal='.',
                       lineterminator='\n')
    data = data.dropna(subset=['CARRIER_DELAY'])

    united = data[data.OP_UNIQUE_CARRIER == "UA"]
    american = data[data.OP_UNIQUE_CARRIER == "AA"]
    southwest = data[data.OP_UNIQUE_CARRIER == "WN"]
    delta = data[data.OP_UNIQUE_CARRIER == "DL"]

    major = pd.concat([united, american, southwest, delta], axis=0)

    month = pd.DataFrame.sample(major, n=500)
    month = month.drop(['CANCELLATION_CODE'], axis=1)

    dataset = pd.concat([dataset, month], axis=0)

    pd.DataFrame.to_csv(month, "trimmed_data\{}_trimmed.csv".format(month_names[filenum-1]))

dataset = dataset.drop(columns='Unnamed: 37')
dataset = dataset.drop(columns='YEAR')
pd.DataFrame.to_csv(dataset, "trimmed_data\dataset_trimmed.csv", index=False)





