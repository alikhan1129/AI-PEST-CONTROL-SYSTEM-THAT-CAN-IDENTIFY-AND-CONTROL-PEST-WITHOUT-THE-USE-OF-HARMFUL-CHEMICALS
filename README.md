# 🐛 Pest Detection & Pesticide Recommendation System — Flutter + Flask + AI

This application is a **full-stack AI pest management tool** that detects common agricultural pests from images and recommends **natural, non-harmful pesticides**.  
It combines a **TensorFlow MobileNetV2 model** for classification, a **Flask REST API** backend, and a **Flutter mobile frontend** for an end-to-end pest detection workflow.

The system accepts pest images, classifies them into one of 12 categories, fetches natural pesticide recommendations from a curated dataset, and displays results instantly in a mobile app.

-----

📸 **App Screenshots**
<p align="center">
  <img src="https://github.com/user-attachments/assets/97f847ce-908c-4e59-9abd-a87007d530b1" width="250" />
  <img src="https://github.com/user-attachments/assets/c4cbcda6-7c33-4a78-ba46-7c7bac4b2a1b" width="250" />
</p>
-----

## ⭐ Core Features

* **🦋 Pest Image Classification**: Detects pests such as ant, bee, beetle, caterpillar, earthworm, earwig, grasshopper, moth, slug, snail, wasp, and weevil.
* **🌱 Natural Pesticide Recommendation**: Suggests eco-friendly, non-chemical pesticides from a local dataset.
* **📱 Mobile Frontend**: Flutter-based UI for easy image uploads and instant results.
* **⚡ REST API Backend**: Flask API processes uploaded images and returns pest classification + pesticide suggestion in JSON format.
* **📦 Offline Support**: TFLite model version available for offline mobile predictions.

-----

## 🛠️ How It Works

1. **Image Capture/Upload**: User takes or selects a pest image in the Flutter app.
2. **API Request**: Image is sent to the Flask backend via POST request.
3. **Preprocessing**: The image is resized to 224×224 and normalized using MobileNetV2’s preprocess function.
4. **Prediction**: The TensorFlow model outputs class probabilities; the highest probability is chosen as the detected pest.
5. **Recommendation**: The pest name is matched in a CSV dataset to retrieve the recommended natural pesticide.
6. **Response**: Backend sends a JSON response with the pest name and recommended pesticide, displayed in the app.

-----

## 🚀 Technology Stack

* **Backend**: Python, Flask, TensorFlow, Pandas, Pillow
* **Frontend**: Flutter, Dart
* **Model**: MobileNetV2 (fine-tuned)
* **Data Storage**: CSV for pesticide mapping
* **Deployment**: Local or cloud-hosted Flask API

-----

## 🔧 Setup and Installation

### 1. Prerequisites
* Python **3.9+**
* Flutter SDK installed
* pip for Python dependencies

### 2. Clone the Repository
```bash
git clone <repository-url>
cd <repository-directory>
```

### 3. Backend Setup

```bash
cd backend
pip install -r requirements.txt
python app.py
```

### 4. Frontend Setup

```bash
cd frontend_flutter
flutter pub get
flutter run
```

---

## ▶️ Usage

**Backend API Endpoint**:

```
POST /predict
```

**Form Data**:

* `image` — pest image file

**Example**:

```bash
curl -X POST -F "image=@ant.jpg" http://localhost:5000/predict
```

**Response**:

```json
{
  "pest": "ant",
  "recommended_pesticide": "Neem Oil"
}
```

---

## 📂 Project Structure

```
project/
├── backend/
│   ├── app.py                 # Flask API
│   ├── data/                  # CSV pesticide dataset
│   ├── model/                 # Trained .h5 model
│   ├── uploads/               # Uploaded images
│   └── requirements.txt
│
├── frontend_flutter/          # Flutter app
│   ├── lib/                   # Dart code
│   ├── assets/
│   ├── android/ ios/ web/ etc.
│
├── ML/
│   ├── agriculture pests image dataset/
│   └── notebook/              # Jupyter notebook & models
│
├── image_test/                # Test images
├── demo/                      # App screenshots
└── README.md
```


