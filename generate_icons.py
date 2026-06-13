import os
import json
from PIL import Image

def generate_icons(source_image_path, target_dir):
    os.makedirs(target_dir, exist_ok=True)
    
    try:
        img = Image.open(source_image_path)
    except Exception as e:
        print(f"Error opening image: {e}")
        return

    # Ensure RGB mode (no alpha for app icon background)
    if img.mode in ('RGBA', 'LA') or (img.mode == 'P' and 'transparency' in img.info):
        background = Image.new('RGB', img.size, (255, 255, 255))
        background.paste(img, mask=img.split()[3]) 
        img = background
    elif img.mode != 'RGB':
        img = img.convert('RGB')

    images_info = [
        {"size": 20, "idiom": "iphone", "scale": 2},
        {"size": 20, "idiom": "iphone", "scale": 3},
        {"size": 20, "idiom": "ipad", "scale": 1},
        {"size": 20, "idiom": "ipad", "scale": 2},
        {"size": 29, "idiom": "iphone", "scale": 1},
        {"size": 29, "idiom": "iphone", "scale": 2},
        {"size": 29, "idiom": "iphone", "scale": 3},
        {"size": 29, "idiom": "ipad", "scale": 1},
        {"size": 29, "idiom": "ipad", "scale": 2},
        {"size": 40, "idiom": "iphone", "scale": 2},
        {"size": 40, "idiom": "iphone", "scale": 3},
        {"size": 40, "idiom": "ipad", "scale": 1},
        {"size": 40, "idiom": "ipad", "scale": 2},
        {"size": 60, "idiom": "iphone", "scale": 2},
        {"size": 60, "idiom": "iphone", "scale": 3},
        {"size": 76, "idiom": "ipad", "scale": 1},
        {"size": 76, "idiom": "ipad", "scale": 2},
        {"size": 83.5, "idiom": "ipad", "scale": 2},
        {"size": 1024, "idiom": "ios-marketing", "scale": 1}
    ]

    contents = {
        "images": [],
        "info": {
            "author": "xcode",
            "version": 1
        }
    }

    for info in images_info:
        size = info["size"]
        scale = info["scale"]
        idiom = info["idiom"]
        
        pixel_size = int(size * scale)
        filename = f"Icon-{size}x{size}@{scale}x.png"
        if idiom == "ios-marketing":
            filename = "Icon-1024.png"

        # Resize image
        resized = img.resize((pixel_size, pixel_size), Image.Resampling.LANCZOS)
        resized.save(os.path.join(target_dir, filename), "PNG")

        # Create json entry
        size_str = f"{size}x{size}" if int(size) == size else f"{size}x{size}" # handled floats like 83.5
        image_entry = {
            "size": f"{size:g}x{size:g}",
            "idiom": idiom,
            "filename": filename,
            "scale": f"{scale}x"
        }
        contents["images"].append(image_entry)

    # Write Contents.json
    with open(os.path.join(target_dir, "Contents.json"), "w") as f:
        json.dump(contents, f, indent=2)
        
    print("App Icons generated successfully!")

if __name__ == "__main__":
    source = "logo_clean.png"
    target = "LUMA/Assets.xcassets/AppIcon.appiconset"
    generate_icons(source, target)
