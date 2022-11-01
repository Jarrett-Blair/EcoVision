# For more information, see Concatenate.ipynb

from tensorflow.keras.layers import Dense, BatchNormalization, GlobalAveragePooling2D, Dropout, Activation
from tensorflow.keras.applications.resnet50 import ResNet50
from tensorflow.keras.models import Model
from tensorflow.keras.layers import concatenate
from sklearn.preprocessing import LabelEncoder
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
ann = Model(inputs, annx)

base_model = ResNet50(include_top = False, weights = 'imagenet')
x = base_model.output
x = GlobalAveragePooling2D()(x)
x = Dense(1024)(x)
x = BatchNormalization()(x)
x = Activation('relu')(x)
x = Dropout(0.3)(x)
x = Dense(128)(x)
x = BatchNormalization()(x)
x = Activation('relu')(x)
x = Dropout(0.3)(x)
resnet = Model(inputs = base_model.input, outputs = x)

for layer in base_model.layers:
    layer.trainable = False
    
concat = concatenate([ann.output, resnet.output])

combined = Dense(128)(concat)
combined = BatchNormalization()(combined)
combined = Activation('relu')(combined)
combined = Dropout(0.3)(combined)
combined = Dense(num_class, activation = "softmax")(combined)
model = Model(inputs = [ann.input, resnet.input], outputs = combined)
    
model.compile(optimizer = 'adam', loss = 'categorical_crossentropy', metrics = ['accuracy'])

model.fit(x=[X,images], y=dummy_y,
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

preds = model.predict([testX, testimages])
