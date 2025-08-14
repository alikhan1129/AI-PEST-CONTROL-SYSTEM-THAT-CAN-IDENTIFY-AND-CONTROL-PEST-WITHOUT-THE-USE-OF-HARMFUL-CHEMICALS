import os
import numpy as np
import pandas as pd
from flask import Flask, request, jsonify
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
from tensorflow.keras.applications.mobilenet_v2 import preprocess_input
from werkzeug.utils import secure_filename

# Load model and CSV
model = load_model("C:\\Users\\alikh\\Desktop\\project\\backend\\model\\pest_identifier_mobilenetv2_finetuned.h5")
pesticides_df = pd.read_csv("C:\\Users\\alikh\\Desktop\\project\\backend\\data\\natural_pesticides.csv")
pest_to_pesticide = dict(zip(pesticides_df['Pest'], pesticides_df['Pesticide (Natural/Non-Harmful)']))

# Class labels (must match training order)
class_labels = [
    'ant', 'bee', 'beetle', 'caterpillar', 'earthworm',
    'earwig', 'grasshopper', 'moth', 'slug', 'snail',
    'wasp', 'weevil'
]

# Initialize Flask app
app = Flask(__name__)
UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image file uploaded'}), 400

    file = request.files['image']
    filename = secure_filename(file.filename)
    filepath = os.path.join(UPLOAD_FOLDER, filename)
    file.save(filepath)

    # Preprocess image
    img = image.load_img(filepath, target_size=(224, 224))
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array = preprocess_input(img_array)

    # Prediction
    predictions = model.predict(img_array)
    pred_index = np.argmax(predictions[0])
    pest = class_labels[pred_index]
    pesticide = pest_to_pesticide.get(pest, "No pesticide found")

    return jsonify({
        'pest': pest,
        'recommended_pesticide': pesticide
    })

# Run the app
if __name__ == '__main__':
    app.run(debug=True)


#curl -X POST -F "image=@C:\Users\alikh\Desktop\project\backend\ant.jpg"  http://localhost:5000/predict