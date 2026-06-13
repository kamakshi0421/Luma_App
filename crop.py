from PIL import Image

def crop_logo(input_path, output_path):
    img = Image.open(input_path).convert("RGB")
    pixels = img.load()
    width, height = img.size
    
    # Find bounding box of non-black pixels (thresholding black)
    min_x, min_y = width, height
    max_x, max_y = 0, 0
    
    # We look for pixels that are not very dark (black threshold)
    for x in range(width):
        for y in range(height):
            r, g, b = pixels[x, y]
            # If it's not black/very dark
            if r > 30 or g > 30 or b > 30:
                if x < min_x: min_x = x
                if x > max_x: max_x = x
                if y < min_y: min_y = y
                if y > max_y: max_y = y
                
    # Add a tiny bit of padding to avoid cutting too much, or actually we might just crop exactly
    # Since it's a rounded rect, the bounding box of non-black pixels will just be the bounding box of the rounded rect.
    print(f"Original size: {width}x{height}")
    print(f"Bounding box: {min_x}, {min_y}, {max_x}, {max_y}")
    
    cropped = img.crop((min_x, min_y, max_x, max_y))
    # Note: iOS app icons are usually square. Let's make it a perfect square
    w = max_x - min_x
    h = max_y - min_y
    size = min(w, h)
    
    # Center crop to perfect square
    left = (w - size) / 2
    top = (h - size) / 2
    right = (w + size) / 2
    bottom = (h + size) / 2
    
    square_crop = cropped.crop((left, top, right, bottom))
    square_crop.save(output_path)
    print(f"Saved cropped image to {output_path}")

if __name__ == "__main__":
    crop_logo("logo.jpg", "logo_cropped.png")
