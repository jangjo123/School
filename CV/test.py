import cv2
import numpy as np
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense

# 데이터셋의 경로와 클래스 레이블
dataset_path = 'dataset/'
class_labels = ['1000', '5000', '10000']

# 데이터셋을 불러와서 전처리
def load_dataset():
    images = []
    labels = []
    for label in class_labels:
        for i in range(1, 9):
            image_path = dataset_path + label + '/' + str(i) + '.jpg'
            image = cv2.imread(image_path)
            image = cv2.resize(image, (64, 64))
            images.append(image)
            labels.append(class_labels.index(label))
    return np.array(images), np.array(labels)

# 데이터셋 로드
X, y = load_dataset()

# 데이터 전처리
X = X / 255.0
y = np.eye(len(class_labels))[y]

# CNN 모델 정의
model = Sequential()
model.add(Conv2D(32, (3, 3), activation='relu', input_shape=(64, 64, 3)))
model.add(MaxPooling2D((2, 2)))
model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(MaxPooling2D((2, 2)))
model.add(Flatten())
model.add(Dense(64, activation='relu'))
model.add(Dense(len(class_labels), activation='softmax'))

# 모델 컴파일
model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

# 모델 훈련
model.fit(X, y, epochs=10, batch_size=32)

# 테스트 이미지 로드
test_image = cv2.imread('test.jpg')
test_image = cv2.resize(test_image, (64, 64))
test_image = np.expand_dims(test_image, axis=0) / 255.0

# 예측 수행
predictions = model.predict(test_image)
predicted_label = class_labels[np.argmax(predictions)]

print('Predicted Label:', predicted_label)
