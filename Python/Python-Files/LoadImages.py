# For more information, see LoadImages.ipynb

# Seed value
# Apparently you may use different seed values at each stage
seed_value= 123

# 1. Set the `PYTHONHASHSEED` environment variable at a fixed value
import os
os.environ['PYTHONHASHSEED']=str(seed_value)

# 2. Set the `python` built-in pseudo-random generator at a fixed value
import random
random.seed(seed_value)

# 3. Set the `numpy` pseudo-random generator at a fixed value
import numpy as np
np.random.seed(seed_value)

# 4. Set the `tensorflow` pseudo-random generator at a fixed value
import tensorflow as tf
tf.random.set_seed(seed_value)
# for later versions: 
# tf.compat.v1.set_random_seed(seed_value)

session_conf = tf.compat.v1.ConfigProto(intra_op_parallelism_threads=1, inter_op_parallelism_threads=1)
sess = tf.compat.v1.Session(graph=tf.compat.v1.get_default_graph(), config=session_conf)
tf.compat.v1.keras.backend.set_session(sess)

from tensorflow.keras.applications.resnet50 import preprocess_input
from tensorflow.keras.preprocessing.image import ImageDataGenerator
import numpy as np

img_height, img_width = (224,224)
batch_size = 49337

train_data_dir = "C:/Carabid_Data/Invert/computer-vision/JPG/training"

train_datagen = ImageDataGenerator(preprocessing_function = preprocess_input,
                                   shear_range = 0.2,
                                   zoom_range = 0.2,
                                   horizontal_flip = True,
                                   vertical_flip = True)

train_generator = train_datagen.flow_from_directory(
    train_data_dir,
    target_size = (img_height, img_width),
    batch_size = batch_size,
    seed = seed_value,
    shuffle = True,
    class_mode = 'categorical')

name_list = list()
datagen = train_generator
batches_per_epoch = datagen.samples // datagen.batch_size + (datagen.samples % datagen.batch_size > 0)
for i in range(batches_per_epoch):
    batch = next(datagen)
    current_index = ((datagen.batch_index-1) * datagen.batch_size)
    if current_index < 0:
        if datagen.samples % datagen.batch_size > 0:
            current_index = max(0,datagen.samples - datagen.samples % datagen.batch_size)
        else:
            current_index = max(0,datagen.samples - datagen.batch_size)
    index_array = datagen.index_array[current_index:current_index + datagen.batch_size].tolist()
    img_paths = [datagen.filepaths[idx] for idx in index_array]
    name_list.extend(img_paths)

images = train_generator[0][0]