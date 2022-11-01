# For more information, see ANN.ipynb

from sklearn.preprocessing import LabelEncoder
from tensorflow.keras.layers import Dense
from tensorflow.keras.models import Model
from keras.utils import np_utils
from keras.layers import Input
import pandas as pd
import numpy as np
import os

os.chdir(r"C:\Carabid_Data\Invert")
df = pd.read_csv("shuffletrain.csv")

Y = df['AllTaxa']
X = df.drop(["AllTaxa"], axis=1)
# convert to numpy arrays
X = np.array(X)
# work with labels
# encode class values as integers
encoder = LabelEncoder()
encoder.fit(Y)
encoded_Y = encoder.transform(Y)
# convert integers to dummy variables (i.e. one hot encoded)
dummy_y = np_utils.to_categorical(encoded_Y)

ncol = X.shape[1]
num_class = dummy_y.shape[1]
inputs = Input(shape = (ncol,))
annx = Dense(128, activation = 'relu')(inputs)
predict = Dense(num_class, activation = "softmax")(annx)
ann = Model(inputs, predict)

ann.compile(optimizer = 'adam', loss = 'categorical_crossentropy', metrics = ['accuracy'])

ann.fit(
    x=X, y=dummy_y,
    epochs=10, batch_size=128,
    verbose = 1)

testdf = pd.read_csv("shuffletestlitl.csv")
testX = testdf.drop(["AllTaxa"], axis = 1)
testY = testdf["AllTaxa"]
encoder = LabelEncoder()
encoder.fit(testY)
encoded_testY = encoder.transform(testY)
# convert integers to dummy variables (i.e. one hot encoded)
dummy_testY = np_utils.to_categorical(encoded_testY)

preds = model.predict(testX)
