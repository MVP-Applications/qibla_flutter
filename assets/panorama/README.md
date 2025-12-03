# 🕋 360° Kaaba Panorama Image

## 📥 Add Your 360° Panorama Here

### What You Need

A **360° equirectangular panorama image** of the Kaaba.

**File name**: `kaaba_360.jpg`

### 📐 Image Requirements

- **Format**: JPG or PNG
- **Aspect Ratio**: 2:1 (e.g., 4096x2048, 8192x4096)
- **Projection**: Equirectangular (360° x 180°)
- **Size**: Under 10MB recommended
- **Quality**: High resolution for best experience

### 🔍 Where to Get 360° Kaaba Images

#### Option 1: Google Street View (Recommended)
1. Go to Google Maps
2. Search "Kaaba, Mecca"
3. Enter Street View mode
4. Look for 360° photo spheres
5. Download using browser tools or extensions

#### Option 2: 360° Photo Websites
- **360Cities**: https://www.360cities.net/search?utf8=✓&query=kaaba
- **Kuula**: https://kuula.co/search?q=kaaba
- **Flickr 360**: https://www.flickr.com/search/?text=kaaba%20360

#### Option 3: YouTube 360° Videos
1. Find 360° Kaaba video on YouTube
2. Extract frame using video tools
3. Convert to equirectangular image

#### Option 4: Create Your Own
- Use 360° camera (Ricoh Theta, Insta360)
- Visit Kaaba (if possible)
- Take 360° photo
- Export as equirectangular

### 📁 Setup

```bash
# 1. Download or create 360° image
# 2. Rename to kaaba_360.jpg
# 3. Copy to this folder

cp ~/Downloads/your-360-image.jpg assets/panorama/kaaba_360.jpg

# 4. Update dependencies
flutter pub get

# 5. Test
flutter run
```

### 🎨 Image Conversion

If you have a regular panorama that's not equirectangular:

**Online Tools:**
- https://www.360toolkit.co/convert-spherical-equirectangular.html
- https://renderstuff.com/tools/360-panorama-web-viewer-converter/

**Software:**
- **Hugin**: Free panorama stitching tool
- **PTGui**: Professional panorama software
- **Photoshop**: Has equirectangular projection

### 📊 Recommended Resolutions

| Resolution | Quality | File Size | Use Case |
|------------|---------|-----------|----------|
| 2048x1024 | Low | 500KB-1MB | Testing |
| 4096x2048 | Medium | 1-3MB | Good |
| 8192x4096 | High | 3-8MB | Best |
| 16384x8192 | Ultra | 8-20MB | Professional |

### 🎯 What Makes a Good 360° Image

✅ **Good:**
- Clear view of Kaaba
- Good lighting
- High resolution
- Proper equirectangular projection
- Minimal distortion

❌ **Avoid:**
- Blurry images
- Low resolution
- Wrong projection
- Heavy watermarks
- Dark/underexposed

### 🔄 Test Your Image

1. **Check aspect ratio**: Should be 2:1
2. **Check projection**: Should be equirectangular
3. **Check seam**: Left and right edges should connect seamlessly
4. **Check poles**: Top and bottom should be properly mapped

### 🧪 Quick Test

```bash
# Add your image
cp ~/Downloads/kaaba_360.jpg assets/panorama/

# Run app
flutter pub get
flutter run

# Test 360° view
1. Tap "360° View" button
2. Rotate device
3. Check if image wraps correctly
4. Verify no seams or distortion
```

### 🎨 Example Sources

**Free 360° Images:**
- Wikimedia Commons 360° category
- Flickr Creative Commons 360°
- Google Street View (with permission)

**Paid 360° Images:**
- Shutterstock 360°
- Adobe Stock 360°
- Getty Images 360°

### 📐 Convert Regular Photo to 360°

If you only have regular Kaaba photos:

1. **Use Panorama Stitching:**
   - Take multiple overlapping photos
   - Use Hugin or PTGui to stitch
   - Export as equirectangular

2. **Use AI Tools:**
   - Some AI tools can generate 360° from single image
   - Quality may vary

3. **Use 3D Rendering:**
   - Create 3D model of Kaaba
   - Render 360° view
   - Export as equirectangular

### 🎯 Current Status

- [ ] Downloaded 360° Kaaba image
- [ ] Converted to equirectangular (if needed)
- [ ] Renamed to kaaba_360.jpg
- [ ] Copied to assets/panorama/
- [ ] Ran flutter pub get
- [ ] Tested in app

### 🐛 Troubleshooting

**Image doesn't show:**
- Check file name is exactly `kaaba_360.jpg`
- Check file is in `assets/panorama/` folder
- Run `flutter pub get`
- Rebuild app

**Image looks distorted:**
- Check aspect ratio is 2:1
- Verify equirectangular projection
- Try different image

**Image has seam:**
- Left and right edges don't match
- Use proper 360° image
- Check projection type

**Image is too large:**
- Compress using online tools
- Reduce resolution
- Convert to JPG with lower quality

### 📚 Resources

- **360° Basics**: https://en.wikipedia.org/wiki/Equirectangular_projection
- **Hugin Tutorial**: http://hugin.sourceforge.net/tutorials/
- **360° Viewer**: https://pannellum.org/
- **Image Converter**: https://www.360toolkit.co/

### 🎉 Result

Once you add a 360° image, users will:
- ✅ See immersive 360° view of Kaaba
- ✅ Rotate device to look around
- ✅ Feel like standing in front of Kaaba
- ✅ Get haptic feedback when facing Qibla
- ✅ See compass showing Qibla direction

---

**Need help?** Check the main documentation or search for "360° equirectangular Kaaba" online!
