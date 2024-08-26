import Foundation
#if !os(macOS)
import CoreMotion
#endif

@available(macOS 14.0, *)
@available(iOS 17.0, *)
public class MotionKit: MotionsManagerServiceDelegate {
    public var liveMotion: Motion = Motion()
    
    private var motionsManagerService: MotionsManagerService
    private var motionUpdateCount = 0
    
    #if !os(macOS)
    private var motionManager = CMMotionManager()
    #endif
    
    public init(queueCount: Int, capacity: Int) {
        self.motionsManagerService = MotionsManagerService(queueCount: queueCount, capacity: capacity)
        self.motionsManagerService.delegate = self
        startAccelerometerUpdates()
    }
    
    private func startAccelerometerUpdates() {
        #if !os(macOS)
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] data, error in
                guard let self = self else { return }
                
                if let accelerometerData = data {
                    let motion = Motion(accelerometer: SensorData(x: accelerometerData.acceleration.x, y: accelerometerData.acceleration.y, z: accelerometerData.acceleration.z))
                    self.liveMotion = motion
                    
                    // Record the motion in MotionsManagerService
                    self.motionsManagerService.recordMotion(accelerometer: motion.accelerometer, gyroscope: motion.gyroscope)
                    
                    self.motionUpdateCount += 1
                    // Optionally, save motions periodically or based on a condition
                    if self.motionUpdateCount % 100 == 0 {  // Example condition
                        let savedMotions = self.motionsManagerService.getCachedMotions()
                        print("Cached motions: \(savedMotions)")
                    }
                } else if let error = error {
                    print("Accelerometer update error: \(error.localizedDescription)")
                }
            }
        }
        #endif
    }
    
    // MARK: - MotionsManagerServiceDelegate
    
    public func didUpdateMotions() {
        // Handle updates from MotionsManagerService
        let cachedMotions = motionsManagerService.getCachedMotions()
        print("Motions updated: \(cachedMotions)")
    }
}
