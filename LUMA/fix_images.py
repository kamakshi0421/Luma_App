import os
from PIL import Image

assets_dir = "/Users/kamakshi/Documents/GitHub/Luma_App/LUMA/Assets.xcassets"
for folder in os.listdir(assets_dir):
    if folder.startswith("stage_") and folder.endswith(".imageset"):
        folder_path = os.path.join(assets_dir, folder)
        for file in os.listdir(folder_path):
            if file.endswith(".png") or file.endswith(".jpg"):
                img_path = os.path.join(folder_path, file)
                try:
                    img = Image.open(img_path)
                    # crop 2 pixels from all sides
                    w, h = img.size
                    cropped = img.crop((2, 2, w-2, h-2))
                    cropped.save(img_path)
                    print(f"Cropped {file}")
                except Exception as e:
                    print(f"Failed on {file}: {e}")
