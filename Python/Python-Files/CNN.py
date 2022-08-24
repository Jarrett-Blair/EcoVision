# For more information, see CNN.ipynb

from tensorflow.keras.layers import Dense, BatchNormalization, GlobalAveragePooling2D, Dropout, Activation
from tensorflow.keras.applications.resnet50 import ResNet50
from tensorflow.keras.models import Model
from sklearn.preprocessing import LabelEncoder
from keras.utils import np_utils
import pandas as pd
import os

os.chdir(r"C:\Carabid_Data\Invert")
df = pd.read_csv("shuffletrain.csv")

Y = df['AllTaxa']
encoder = LabelEncoder()
encoder.fit(Y)
encoded_Y = encoder.transform(Y)
# convert integers to dummy variables (i.e. one hot encoded)
dummy_y = np_utils.to_categorical(encoded_Y)

num_class = dummy_y.shape[1]

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
predict = Dense(num_class, activation = "softmax")(x)
resnet = Model(inputs = base_model.input, outputs = predict)

for layer in base_model.layers:
    layer.trainable = False
    
resnet.compile(optimizer = 'adam', loss = 'categorical_crossentropy', metrics = ['accuracy'])

resnet.fit(
	x=images, y=dummy_y,
	epochs=10, batch_size=128,
    verbose = 1)

preds = resnet.predict(valimages)