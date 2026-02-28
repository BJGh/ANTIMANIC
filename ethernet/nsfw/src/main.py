import json
import base64
import io
from PIL import Image
from opennsfw2 import predict_image

async def main(req, res):
    try:
        data = json.loads(req.body)
        image_base64 = data.get('image')
        image_data = base64.b64decode(image_base64)
        image = Image.open(io.BytesIO(image_data))
        nsfw_score = predict_image(image)
        result = {
            'nsfw_score': float(nsfw_score),
            'is_nsfw': nsfw_score > 0.7,
            'confidence': 'high' if nsfw_score > 0.7 or nsfw_score < 0.2 else 'medium'
        }
        return res.json(result)
    except Exception as e:
        return res.json({'error': str(e)}, 500)
