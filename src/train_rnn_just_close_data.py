import pandas as pd
import numpy as np
from matplotlib import pyplot

from sklearn import metrics
from sklearn.preprocessing import MinMaxScaler

from keras.models import Sequential
from keras.layers import Dense
from keras.layers import LSTM
from keras.layers import Dropout


from gameStopStockPrediction.src.own_metrics_and_other_utils import mda

train_threshold = 60
batch_size = 5
neurons = 10
epochs = 300
hidden_layers = 3


# beste momentan 2 hidden 15 neurons 150 epochs oder aber 1 hidden 15 neurons batch size 10 epochs =200


def build_model(number_hidden_layers, number_neurons, number_epochs):
    # build model
    model = Sequential()

    for i in range(1, number_hidden_layers + 1):
        if i == number_hidden_layers and number_hidden_layers == 1:
            model.add(LSTM(units=number_neurons, return_sequences=False, input_shape=
            (X_train.shape[1], X_train.shape[2])))
            model.add(Dropout(0.2))
        elif i == 1:
            model.add(LSTM(units=number_neurons, return_sequences=True, input_shape=
            (X_train.shape[1], X_train.shape[2])))
            model.add(Dropout(0.2))
        elif i == number_hidden_layers:
            model.add(LSTM(units=number_neurons, return_sequences=False))
            model.add(Dropout(0.2))
        else:
            model.add(LSTM(units=number_neurons, return_sequences=True))
            model.add(Dropout(0.2))

    # output layer
    model.add(Dense(units=1))

    model.compile(optimizer="adam", loss="mean_absolute_percentage_error")
    model.fit(X_train, y_train, epochs=number_epochs, batch_size=1)
    return model


# read in csv and divide data into train and test
df = pd.read_csv("../input/GME_04Jan_11May.csv")
train_data = df.iloc[:train_threshold, 4:5].values
test_data = df.iloc[train_threshold:, 4:5].values

# normalize data
normalizer = MinMaxScaler(feature_range=(0, 1))
train_data_normalized = normalizer.fit_transform(train_data)

# transform data for input in model
X_train = []
y_train = []
for i in range(batch_size, train_threshold):
    X_train.append(train_data_normalized[i - batch_size:i, 0:1])
    y_train.append(train_data_normalized[i, 0:1])
X_train = np.array(X_train)
y_train = np.array(y_train)

X_train = np.reshape(X_train, (X_train.shape[0], X_train.shape[1], 1))

# prepare input data for prediction
X_test = []
inputs = df.iloc[:, 4:5]
inputs = inputs[len(inputs) - len(test_data) - batch_size:].values
inputs = inputs.reshape(-1, 1)
inputs = normalizer.transform(inputs)

for i in range(batch_size, len(inputs)):
    X_test.append(inputs[i - batch_size:i, 0])
X_test = np.array(X_test)
X_test = np.reshape(X_test, (X_test.shape[0], X_test.shape[1], 1))



model = build_model(hidden_layers, neurons, epochs)
predicted_stock_price = model.predict(X_test)
predicted_stock_price = normalizer.inverse_transform(predicted_stock_price)

# Metrics
print("MAE:", metrics.mean_absolute_error(test_data, predicted_stock_price))
print("MAPE:", metrics.mean_absolute_percentage_error(test_data, predicted_stock_price) * 100)
print("MDA", mda(test_data, predicted_stock_price) * 100)

pyplot.plot(test_data, label="Echte Kursdaten")
pyplot.plot(predicted_stock_price, label="Predictions")
pyplot.legend()
pyplot.show()
