// Utility function to safely load images and handle format issues
export function loadImageSafely(src: string): Promise<HTMLImageElement> {
  return new Promise((resolve, reject) => {
    const img = new Image();
    
    img.onload = () => {
      resolve(img);
    };
    
    img.onerror = (error) => {
      // If there's an error loading the image, try to handle it gracefully
      console.warn(`Failed to load image: ${src}`, error);
      reject(error);
    };
    
    // Set crossOrigin attribute if needed
    if (src.startsWith('http')) {
      img.crossOrigin = 'anonymous';
    }
    
    img.src = src;
  });
}

// Utility function to detect image type from data URL
export function getImageTypeFromDataUrl(dataUrl: string): string | null {
  const match = dataUrl.match(/^data:image\/([a-zA-Z]+);base64,/);
  return match ? match[1] : null;
}

// Utility function to convert between image formats if needed
export function convertImageFormatIfNeeded(
  dataUrl: string, 
  targetFormat: 'jpeg' | 'png' = 'jpeg'
): string {
  const currentType = getImageTypeFromDataUrl(dataUrl);
  
  // If the current type matches target or we can't determine the type, return as is
  if (!currentType || currentType === targetFormat) {
    return dataUrl;
  }
  
  // For now, we'll just log a warning and return the original
  // In a more robust implementation, you might want to actually convert the image
  console.warn(`Image format mismatch: expected ${targetFormat}, got ${currentType}`);
  return dataUrl;
}