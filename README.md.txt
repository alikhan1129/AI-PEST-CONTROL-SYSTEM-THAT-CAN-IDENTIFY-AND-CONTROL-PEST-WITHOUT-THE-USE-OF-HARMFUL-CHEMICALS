

```markdown
# 🐛 Pest Detection & Pesticide Recommendation System

This project is an **AI-powered pest identification system** with **natural pesticide recommendations**.  
It uses a **MobileNetV2** deep learning model and has:
- **Flask backend API** for pest detection.
- **Flutter mobile frontend** for user interaction.
- A dataset of pest images and natural pesticides.

---

## 📂 Project Structure
```

project/
│── backend/                 # Flask backend API
│   ├── app.py
│   ├── data/                 # CSV with pesticide info
│   ├── model/                # Trained ML model (.h5)
│   ├── uploads/              # Uploaded images
│   └── requirements.txt
│
│── frontend\_flutter/         # Flutter mobile app
│   ├── lib/                  # Dart code
│   ├── assets/
│   ├── android/ ios/ web/ etc.
│
│── ML/
│   ├── agriculture pests image dataset/  # Training images
│   └── notebook/                         # Model training notebook & saved models
│
│── image\_test/               # Test images for evaluation
│── README.md
│── .gitignore

````

---

## 🚀 Features
- **Image-based pest detection** (12 classes: ant, bee, beetle, caterpillar, earthworm, earwig, grasshopper, moth, slug, snail, wasp, weevil).
- **Natural pesticide recommendation** from CSV dataset.
- **Cross-platform mobile app** built with Flutter.
- Works offline for prediction (if model is embedded in app).

---

## ⚙️ Installation

### Backend (Flask API)
```bash
cd backend
pip install -r requirements.txt
python app.py
````

### Frontend (Flutter)

```bash
cd frontend_flutter
flutter pub get
flutter run
```

---

## 🔍 API Usage

**Endpoint:**

```
POST /predict
```

**Form Data:**

* `image`: image file of the pest.

Example:

```bash
curl -X POST -F "image=@path_to_image.jpg" http://localhost:5000/predict
```

Response:

```json
{
  "pest": "ant",
  "recommended_pesticide": "Neem Oil"
}
```

---

## 📊 Model

* Architecture: **MobileNetV2** fine-tuned.
* Input Size: **224x224**
* Output Classes: 12 pest species.
* Stored as `.h5` and `.tflite` for mobile.

---

## 🎥 Demo

![App Screenshot](demo/demo1.png)
![Detection Result](demo/demo2.png)

---

## 📜 License

MIT License.

```


