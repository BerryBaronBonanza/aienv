import requests
from PIL import Image
url = "http://images.cocodataset.org/val2017/000000039769.jpg"
image = Image.open(requests.get(url, stream=True).raw)
print(image)

# see https://github.com/minimaxir/imgbeddings

from imgbeddings import imgbeddings
ibed = imgbeddings()
embedding = ibed.to_embeddings(image)
print(embedding)

