from PIL import Image

def remove_black_corners(input_path, output_path):
    img = Image.open(input_path).convert("RGB")
    pixels = img.load()
    width, height = img.size
    
    # Sample the background color from top-center (assuming it's pink)
    bg_color = pixels[width // 2, 10]
    print(f"Detected background color: {bg_color}")
    
    # We will replace dark pixels with the bg_color
    # A pixel is considered dark if it's close to black
    def is_dark(color):
        return color[0] < 50 and color[1] < 50 and color[2] < 50
        
    for x in range(width):
        for y in range(height):
            # Check if pixel is dark
            if is_dark(pixels[x, y]):
                pixels[x, y] = bg_color
                
    img.save(output_path)
    print(f"Saved processed image to {output_path}")

if __name__ == "__main__":
    remove_black_corners("logo.jpg", "logo_clean.png")
