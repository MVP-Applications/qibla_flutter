# ARCore Technical Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter App Layer                         │
│  (AR Qibla Page → Method Channel → Native Android)          │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              MainActivity (Entry Point)                      │
│  - Receives Qibla bearing from Flutter                      │
│  - Launches ARCoreActivity with bearing                     │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              ARCoreActivity (Main AR View)                  │
│  - Manages GLSurfaceView                                    │
│  - Handles permissions                                      │
│  - Manages sensors (compass, accelerometer)                 │
│  - Calculates Qibla bearing from GPS                        │
└────────────────────┬────────────────────────────────────────┘
                     │
        ┌────────────┼────────────┐
        ▼            ▼            ▼
    ┌────────┐  ┌──────────┐  ┌──────────────┐
    │ Sensors│  │ Location │  │ GLSurfaceView│
    │Manager │  │ Manager  │  │   Renderer   │
    └────────┘  └──────────┘  └──────┬───────┘
                                      │
                                      ▼
                        ┌─────────────────────────┐
                        │   ARCoreManager         │
                        │ (GLSurfaceView.Renderer)│
                        └────────────┬────────────┘
                                     │
                    ┌────────────────┼────────────────┐
                    ▼                ▼                ▼
            ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
            │ ARCore       │  │ Kaaba        │  │ Display      │
            │ Session      │  │ Renderer     │  │ Rotation     │
            │              │  │ (OpenGL ES)  │  │ Helper       │
            └──────────────┘  └──────────────┘  └──────────────┘
```

## Component Details

### 1. MainActivity

**Responsibility**: Entry point and method channel handler

**Key Methods**:
- `configureFlutterEngine()`: Setup method channel
- `startARCoreView()`: Launch ARCore activity

**Flow**:
```
Flutter calls "startARView" 
  → MainActivity receives qiblaBearing
  → Launches ARCoreActivity with bearing
```

### 2. ARCoreActivity

**Responsibility**: Main AR activity, sensor management, location handling

**Key Components**:
- `GLSurfaceView`: Renders AR content
- `SensorManager`: Compass and accelerometer
- `LocationManager`: GPS location updates
- `ARCoreManager`: ARCore session management

**Lifecycle**:
```
onCreate()
  ├─ Initialize views
  ├─ Setup ARCore callbacks
  ├─ Configure GLSurfaceView
  └─ Check permissions

onResume()
  ├─ Resume GLSurfaceView
  └─ Resume ARCore session

onPause()
  ├─ Pause GLSurfaceView
  └─ Pause ARCore session

onDestroy()
  ├─ Unregister sensors
  ├─ Remove location updates
  └─ Cleanup ARCore
```

**Sensor Handling**:
```
Accelerometer + Magnetometer
  → SensorManager.getRotationMatrix()
  → SensorManager.getOrientation()
  → currentHeading (0-360°)
```

**Location Handling**:
```
GPS Location Update
  → calculateQiblaBearing(lat, lon)
  → Update ARCoreManager with new bearing
  → Reposition Kaaba anchor
```

### 3. ARCoreManager

**Responsibility**: ARCore session lifecycle and rendering

**Key Methods**:
- `initializeARSession()`: Create and configure ARCore session
- `setQiblaBearingAndPlaceKaaba()`: Set bearing and trigger anchor creation
- `placeKaabaAnchor()`: Create world anchor at Qibla direction
- `onDrawFrame()`: Render loop

**ARCore Session Configuration**:
```kotlin
config.focusMode = Config.FocusMode.AUTO
config.planeFindingMode = Config.PlaneFindingMode.HORIZONTAL
config.updateMode = Config.UpdateMode.LATEST_CAMERA_IMAGE
```

**Rendering Pipeline**:
```
onDrawFrame()
  ├─ Update display rotation
  ├─ Get current frame
  ├─ Check camera tracking state
  ├─ Get camera matrices (projection, view)
  ├─ Detect planes
  ├─ Create anchor if needed
  ├─ Clear screen
  └─ Render Kaaba
      ├─ Get anchor pose
      ├─ Calculate MVP matrix
      └─ Call KaabaRenderer.render()
```

### 4. KaabaRenderer

**Responsibility**: 3D rendering using OpenGL ES 2.0

**Shader Pipeline**:
```
Vertex Shader
  ├─ Input: vPosition (vertex coordinates)
  ├─ Input: vColor (vertex color)
  ├─ Transform: gl_Position = uMVPMatrix * vPosition
  └─ Output: fragColor

Fragment Shader
  ├─ Input: fragColor (from vertex shader)
  └─ Output: gl_FragColor
```

**Geometry**:
```
Kaaba Cube (0.3m × 0.4m × 0.3m)
  ├─ 8 vertices (corners)
  ├─ 12 triangles (6 faces)
  ├─ Colors: Black with slight variation
  └─ Indices: 36 indices (6 faces × 6 indices)
```

**Rendering Process**:
```
render(mvpMatrix)
  ├─ Use program
  ├─ Set MVP matrix uniform
  ├─ Enable vertex attributes
  ├─ Set vertex position pointer
  ├─ Set vertex color pointer
  ├─ Draw elements (triangles)
  └─ Disable vertex attributes
```

### 5. DisplayRotationHelper

**Responsibility**: Handle display rotation changes

**Key Methods**:
- `onSurfaceChanged()`: Update viewport dimensions
- `updateSessionIfNeeded()`: Update ARCore session if rotation changed

## Data Flow

### Initialization Flow

```
1. MainActivity.onCreate()
   └─ startARCoreView(qiblaBearing)

2. ARCoreActivity.onCreate()
   ├─ Initialize GLSurfaceView
   ├─ Create ARCoreManager
   ├─ Setup callbacks
   └─ Check permissions

3. ARCoreActivity.onResume()
   ├─ GLSurfaceView.onResume()
   └─ ARCoreManager.resumeSession()

4. ARCoreManager.initializeARSession()
   ├─ Create Session
   ├─ Configure session
   ├─ Create DisplayRotationHelper
   └─ Create KaabaRenderer

5. GLSurfaceView.onSurfaceCreated()
   ├─ GLES20.glClearColor()
   ├─ GLES20.glEnable(GL_DEPTH_TEST)
   └─ KaabaRenderer.createProgram()

6. GLSurfaceView.onSurfaceChanged()
   └─ DisplayRotationHelper.onSurfaceChanged()

7. GLSurfaceView.onDrawFrame() [Continuous]
   ├─ ARCoreManager.onDrawFrame()
   ├─ Detect planes
   ├─ Create anchor
   └─ Render Kaaba
```

### Kaaba Placement Flow

```
1. Plane Detected
   └─ ARCoreManager.onPlaneDetected()

2. placeKaabaAnchor(frame)
   ├─ Get camera pose
   ├─ Calculate Kaaba position:
   │  ├─ x = 5 * sin(qibla_bearing_rad)
   │  ├─ y = -0.5
   │  └─ z = -5 * cos(qibla_bearing_rad)
   ├─ Create Pose
   ├─ Create Anchor
   └─ Callback: onKaabaPlaced()

3. Anchor Tracking
   ├─ Get anchor pose
   ├─ Convert to matrix
   ├─ Calculate MVP matrix
   └─ Render Kaaba at anchor position
```

### Sensor Update Flow

```
Compass Event
  ├─ Accelerometer + Magnetometer data
  ├─ SensorManager.getRotationMatrix()
  ├─ SensorManager.getOrientation()
  ├─ Convert to degrees
  └─ Update currentHeading

Location Event
  ├─ Get GPS location
  ├─ calculateQiblaBearing(lat, lon)
  ├─ Update qiblaBearing
  └─ ARCoreManager.setQiblaBearingAndPlaceKaaba()
```

## Coordinate Systems

### World Coordinate System (ARCore)

```
       Y (Up)
       │
       │
       └─────── X (East)
      /
     /
    Z (South)

Origin: Camera position at initialization
```

### Qibla Direction Calculation

```
Given:
  - User location: (latitude, longitude)
  - Kaaba location: (21.4225°N, 39.8262°E)

Calculate:
  1. Convert to radians
  2. Calculate great circle bearing using atan2
  3. Normalize to 0-360°

Result: Bearing angle from North (0°)
```

### Screen Coordinate System

```
(0, 0) ─────────── (width, 0)
  │                    │
  │   GLSurfaceView    │
  │                    │
(0, height) ─── (width, height)
```

## Matrix Transformations

### MVP Matrix Calculation

```
MVP = Projection × View × Model

Where:
  - Projection: Camera frustum (perspective)
  - View: Camera position and orientation
  - Model: Kaaba position and orientation (anchor pose)

Result: Transforms 3D world coordinates to 2D screen coordinates
```

### Anchor Pose to Matrix

```
Anchor.pose.toMatrix(matrix, 0)
  ├─ Converts 7-DOF pose (position + rotation) to 4×4 matrix
  ├─ Position: (x, y, z)
  └─ Rotation: Quaternion (qx, qy, qz, qw)
```

## Performance Considerations

### CPU Usage

- **ARCore Tracking**: ~10-15%
- **OpenGL Rendering**: ~5-10%
- **Sensor Processing**: ~1-2%
- **Total**: ~15-25%

### Memory Usage

- **ARCore Session**: ~50MB
- **OpenGL Buffers**: ~10MB
- **Textures/Models**: ~20-50MB
- **Total**: ~100-150MB

### Battery Drain

- **Camera**: ~30% of total drain
- **GPS**: ~40% of total drain
- **Sensors**: ~10% of total drain
- **Rendering**: ~20% of total drain

## Error Handling

### ARCore Errors

```
UnavailableException
  └─ ARCore not available on device

CameraNotAvailableException
  └─ Camera not accessible

DeadlineExceededException
  └─ Operation took too long

NotTrackingException
  └─ Camera not tracking (poor lighting, motion blur)
```

### Permission Errors

```
Camera Permission Denied
  └─ Cannot access camera

Location Permission Denied
  └─ Cannot get GPS location
```

## Testing Strategy

### Unit Tests

- Qibla bearing calculation
- Coordinate transformations
- Matrix operations

### Integration Tests

- ARCore session lifecycle
- Anchor creation and tracking
- Sensor data processing

### UI Tests

- Permission handling
- Error display
- Status updates

### Performance Tests

- Rendering frame rate
- Memory usage
- Battery drain

## Future Enhancements

### 3D Model Loading

```
Load GLTF/GLB model
  ├─ Parse model file
  ├─ Load vertices and indices
  ├─ Load textures
  └─ Render with proper shaders
```

### Lighting

```
Add lighting calculations
  ├─ Ambient light
  ├─ Directional light (sun)
  ├─ Point lights
  └─ Shadow mapping
```

### Advanced Features

```
- Cloud anchors (multi-device AR)
- Occlusion (real objects in front)
- Physics simulation
- Animation
- Particle effects
```

## References

- [ARCore Architecture](https://developers.google.com/ar/develop/java/concepts)
- [OpenGL ES 2.0 Pipeline](https://www.khronos.org/opengles/)
- [Android Sensor Framework](https://developer.android.com/guide/topics/sensors)
- [Great Circle Distance](https://en.wikipedia.org/wiki/Great-circle_distance)
