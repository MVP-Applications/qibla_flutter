package com.example.qibla_ar_finder

import android.Manifest
import android.content.pm.PackageManager
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.opengl.GLSurfaceView
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.widget.FrameLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.ar.core.ArCoreApk
import kotlin.math.*

/**
 * ARCore Activity - Main AR view using native ARCore
 * Displays Kaaba as a world-anchored 3D object at Qibla direction
 */
class ARCoreActivity : AppCompatActivity(), SensorEventListener, LocationListener {
    
    private lateinit var glSurfaceView: GLSurfaceView
    private lateinit var arCoreManager: ARCoreManager
    private lateinit var statusTextView: TextView
    
    private var sensorManager: SensorManager? = null
    private var locationManager: LocationManager? = null
    
    private var qiblaBearing = 0f
    private var currentHeading = 0f
    
    private val accelerometer = FloatArray(3)
    private val magnetometer = FloatArray(3)
    private val rotationMatrix = FloatArray(9)
    private val orientationAngles = FloatArray(3)
    
    private var lastLocationUpdate = 0L
    private val LOCATION_UPDATE_INTERVAL = 5000L
    
    companion object {
        private const val TAG = "ARCoreActivity"
        private const val PERMISSION_REQUEST_CODE = 100
        private const val CAMERA_PERMISSION = Manifest.permission.CAMERA
        private const val LOCATION_PERMISSION = Manifest.permission.ACCESS_FINE_LOCATION
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_arcore)
        
        // Get Qibla bearing from intent
        qiblaBearing = intent.getFloatExtra("qibla_bearing", 0f)
        Log.d(TAG, "Received Qibla bearing: $qiblaBearing°")
        
        // Initialize views
        glSurfaceView = findViewById(R.id.gl_surface_view)
        statusTextView = findViewById(R.id.status_text)
        
        // Initialize managers
        sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
        locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
        
        // Initialize ARCore
        arCoreManager = ARCoreManager(this)
        
        // Setup callbacks
        setupARCoreCallbacks()
        
        // Configure GLSurfaceView
        glSurfaceView.setEGLContextClientVersion(2)
        glSurfaceView.setRenderer(arCoreManager)
        glSurfaceView.renderMode = GLSurfaceView.RENDERMODE_CONTINUOUSLY
        
        // Check permissions
        checkPermissions()
    }
    
    /**
     * Setup ARCore callbacks
     */
    private fun setupARCoreCallbacks() {
        arCoreManager.onSessionCreated = {
            Log.d(TAG, "ARCore session created")
            updateStatus("ARCore initialized")
            arCoreManager.setQiblaBearingAndPlaceKaaba(qiblaBearing)
        }
        
        arCoreManager.onPlaneDetected = {
            Log.d(TAG, "Plane detected")
            updateStatus("Plane detected - Kaaba placed")
        }
        
        arCoreManager.onKaabaPlaced = {
            Log.d(TAG, "Kaaba placed at Qibla direction")
            updateStatus("Kaaba anchored at Qibla: $qiblaBearing°")
        }
        
        arCoreManager.onError = { error ->
            Log.e(TAG, "ARCore error: $error")
            updateStatus("Error: $error")
        }
    }
    
    /**
     * Check and request permissions
     */
    private fun checkPermissions() {
        val permissions = arrayOf(CAMERA_PERMISSION, LOCATION_PERMISSION)
        val permissionsToRequest = mutableListOf<String>()
        
        for (permission in permissions) {
            if (ContextCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED) {
                permissionsToRequest.add(permission)
            }
        }
        
        if (permissionsToRequest.isNotEmpty()) {
            ActivityCompat.requestPermissions(
                this,
                permissionsToRequest.toTypedArray(),
                PERMISSION_REQUEST_CODE
            )
        } else {
            initializeAR()
        }
    }
    
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        
        if (requestCode == PERMISSION_REQUEST_CODE) {
            if (grantResults.all { it == PackageManager.PERMISSION_GRANTED }) {
                initializeAR()
            } else {
                updateStatus("Permissions denied")
            }
        }
    }
    
    /**
     * Initialize AR
     */
    private fun initializeAR() {
        // Check ARCore availability
        when (ArCoreApk.getInstance().requestInstall(this, true)) {
            ArCoreApk.InstallStatus.INSTALL_REQUESTED -> {
                Log.d(TAG, "ARCore installation requested")
                return
            }
            ArCoreApk.InstallStatus.INSTALLED -> {
                Log.d(TAG, "ARCore installed")
            }
        }
        
        // Initialize ARCore session
        arCoreManager.initializeARSession()
        
        // Start sensor tracking
        startSensorTracking()
        
        // Start location updates
        startLocationUpdates()
        
        updateStatus("Initializing AR...")
    }
    
    /**
     * Start sensor tracking for compass and accelerometer
     */
    private fun startSensorTracking() {
        if (sensorManager == null) {
            Log.e(TAG, "SensorManager not available")
            updateStatus("Sensors not available")
            return
        }
        
        val accelerometerSensor = sensorManager?.getDefaultSensor(android.hardware.Sensor.TYPE_ACCELEROMETER)
        val magnetometerSensor = sensorManager?.getDefaultSensor(android.hardware.Sensor.TYPE_MAGNETIC_FIELD)
        
        if (accelerometerSensor == null || magnetometerSensor == null) {
            Log.e(TAG, "Required sensors not available")
            updateStatus("Required sensors not available")
            return
        }
        
        sensorManager?.registerListener(this, accelerometerSensor, SensorManager.SENSOR_DELAY_UI)
        sensorManager?.registerListener(this, magnetometerSensor, SensorManager.SENSOR_DELAY_UI)
        Log.d(TAG, "Sensor tracking started")
    }
    
    /**
     * Start location updates
     */
    private fun startLocationUpdates() {
        if (locationManager == null) {
            Log.e(TAG, "LocationManager not available")
            updateStatus("Location services not available")
            return
        }
        
        if (ActivityCompat.checkSelfPermission(
                this,
                LOCATION_PERMISSION
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            try {
                locationManager?.requestLocationUpdates(
                    LocationManager.GPS_PROVIDER,
                    LOCATION_UPDATE_INTERVAL,
                    0f,
                    this
                )
                Log.d(TAG, "Location updates started")
            } catch (e: Exception) {
                Log.e(TAG, "Error starting location updates: ${e.message}")
                updateStatus("Error starting location updates")
            }
        } else {
            Log.w(TAG, "Location permission not granted")
        }
    }
    
    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null) return
        
        when (event.sensor.type) {
            android.hardware.Sensor.TYPE_ACCELEROMETER -> {
                System.arraycopy(event.values, 0, accelerometer, 0, 3)
            }
            android.hardware.Sensor.TYPE_MAGNETIC_FIELD -> {
                System.arraycopy(event.values, 0, magnetometer, 0, 3)
            }
        }
        
        // Calculate rotation matrix
        SensorManager.getRotationMatrix(rotationMatrix, null, accelerometer, magnetometer)
        SensorManager.getOrientation(rotationMatrix, orientationAngles)
        
        // Convert radians to degrees
        currentHeading = Math.toDegrees(orientationAngles[0].toDouble()).toFloat()
        
        // Normalize heading to 0-360
        if (currentHeading < 0) {
            currentHeading += 360
        }
        
        // Update UI
        updateCompassDisplay()
    }
    
    override fun onAccuracyChanged(sensor: android.hardware.Sensor?, accuracy: Int) {}
    
    override fun onLocationChanged(location: Location) {
        val currentTime = System.currentTimeMillis()
        if (currentTime - lastLocationUpdate < LOCATION_UPDATE_INTERVAL) {
            return
        }
        lastLocationUpdate = currentTime
        
        // Calculate Qibla bearing from location
        qiblaBearing = calculateQiblaBearing(location.latitude, location.longitude)
        Log.d(TAG, "Location updated: Qibla bearing = $qiblaBearing°")
        
        // Update ARCore with new bearing
        arCoreManager.setQiblaBearingAndPlaceKaaba(qiblaBearing)
        
        // Update UI
        updateCompassDisplay()
    }
    
    /**
     * Update compass display with current heading and Qibla bearing
     */
    private fun updateCompassDisplay() {
        runOnUiThread {
            try {
                findViewById<TextView>(R.id.heading_text)?.text = "${currentHeading.toInt()}°"
                findViewById<TextView>(R.id.qibla_text)?.text = "${qiblaBearing.toInt()}°"
            } catch (e: Exception) {
                Log.e(TAG, "Error updating compass display: ${e.message}")
            }
        }
    }
    
    /**
     * Calculate Qibla bearing from user location
     */
    private fun calculateQiblaBearing(latitude: Double, longitude: Double): Float {
        // Kaaba coordinates
        val kaabaLat = 21.4225
        val kaabaLon = 39.8262
        
        val lat1 = Math.toRadians(latitude)
        val lat2 = Math.toRadians(kaabaLat)
        val dLon = Math.toRadians(kaabaLon - longitude)
        
        val y = sin(dLon) * cos(lat2)
        val x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        
        var bearing = Math.toDegrees(atan2(y, x)).toFloat()
        
        // Normalize to 0-360
        if (bearing < 0) {
            bearing += 360
        }
        
        return bearing
    }
    
    /**
     * Update status text
     */
    private fun updateStatus(message: String) {
        runOnUiThread {
            statusTextView.text = message
        }
    }
    
    override fun onResume() {
        super.onResume()
        glSurfaceView.onResume()
        arCoreManager.resumeSession()
    }
    
    override fun onPause() {
        super.onPause()
        glSurfaceView.onPause()
        arCoreManager.pauseSession()
    }
    
    override fun onDestroy() {
        super.onDestroy()
        sensorManager?.unregisterListener(this)
        locationManager?.removeUpdates(this)
        arCoreManager.cleanup()
    }
}
