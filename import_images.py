import os
import glob
import shutil
import json

brain_dir = "/Users/kamakshi/.gemini/antigravity/brain/bab6a5c2-22be-42fe-97e8-afa508fabb9b"
assets_dir = "/Users/kamakshi/Documents/GitHub/Luma_App/LUMA/images.xcassets"

png_files = glob.glob(os.path.join(brain_dir, "*.png"))

for file_path in png_files:
    basename = os.path.basename(file_path)
    if basename.startswith("media__"):
        continue
    
    # Extract name without the timestamp
    # Format: name_1234567890.png
    parts = basename.rsplit('_', 1)
    if len(parts) != 2:
        continue
    
    image_name = parts[0]
    
    imageset_dir = os.path.join(assets_dir, f"{image_name}.imageset")
    os.makedirs(imageset_dir, exist_ok=True)
    
    # Copy the file
    new_file_path = os.path.join(imageset_dir, f"{image_name}.png")
    shutil.copyfile(file_path, new_file_path)
    
    # Create Contents.json
    contents = {
      "images" : [
        {
          "filename" : f"{image_name}.png",
          "idiom" : "universal",
          "scale" : "1x"
        },
        {
          "idiom" : "universal",
          "scale" : "2x"
        },
        {
          "idiom" : "universal",
          "scale" : "3x"
        }
      ],
      "info" : {
        "author" : "xcode",
        "version" : 1
      }
    }
    
    with open(os.path.join(imageset_dir, "Contents.json"), "w") as f:
        json.dump(contents, f, indent=2)

print("Images imported successfully.")
