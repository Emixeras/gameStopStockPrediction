import pandas as pd
import sklearn.metrics
from sklearn.preprocessing import MinMaxScaler
import numpy as np

df = pd.read_csv("../input/GME.csv")

train_data = df.iloc[:70, 4:5].values
test_data = df.iloc[70:, 4:5].values

normalizer = MinMaxScaler(feature_range=(0, 1))
train_data_normalized = normalizer.fit_transform(train_data)
test_data_normalized = normalizer.fit_transform(test_data)

X_train = []
y_train = []
for i in range(5, 70):
    X_train.append(train_data_normalized[i - 5:i, 0])
    y_train.append(train_data_normalized[i, 0])
X_train = np.array(X_train)
y_train = np.array(y_train)

X_train = np.reshape(X_train, (X_train.shape[0], X_train.shape[1], 1))

from keras.models import Sequential
from keras.layers import Dense
from keras.layers import LSTM
from keras.layers import Dropout

model = Sequential()

# input layer
model.add(LSTM(units=10, return_sequences=False, input_shape=(X_train.shape[1], 1)))
model.add(Dropout(0.2))

# hidden layer
model.add(LSTM(units=10, return_sequences=False))
model.add(Dropout(0.2))


# output layer
model.add(Dense(units=1))

model.compile(optimizer="adam", loss="mean_absolute_percentage_error")
model.fit(X_train, y_train, epochs=100, batch_size=32)
model.loss

X_test = []
for i in range(5, 19):
    X_test.append(test_data_normalized[i-5:i, 0])
X_test = np.array(X_test)
X_test = np.reshape(X_test, (X_test.shape[0], X_test.shape[1], 1))

predicted_stock_price = model.predict(X_test)

predicted_stock_price = normalizer.inverse_transform(predicted_stock_price)

