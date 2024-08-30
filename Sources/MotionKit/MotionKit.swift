import Foundation
#if !os(macOS)
import CoreMotion
#endif

@available(macOS 14.0, *)
@available(iOS 17.0, *)
public class MotionKit {
    public var liveMotion: Motion = Motion()
    
    private var motionsManagerService: MotionsManagerService
    private var motionUpdateCount = 0
    
    #if !os(macOS)
    private var motionManager = CMMotionManager()
    private let motionQueue = DispatchQueue(label: "com.yourapp.motionQueue")
    #endif
    
    public init(queueCount: Int, capacity: Int) {
        self.motionsManagerService = MotionsManagerService(queueCount: queueCount, capacity: capacity)
        startSensorUpdates()
    }
    
    private func startSensorUpdates() {
        #if !os(macOS)
        startAccelerometerUpdates()
        startGyroUpdates()
        startMagnetometerUpdates()
        #endif
    }
    
    #if !os(macOS)
    private func startAccelerometerUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] data, error in
                guard let self = self, let accelerometerData = data else {
                    if let error = error {
                        print("Accelerometer update error: \(error.localizedDescription)")
                    }
                    return
                }
                self.processAccelerometerData(accelerometerData)
            }
        }
    }

    private func startGyroUpdates() {
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates(to: OperationQueue.main) { [weak self] data, error in
                guard let self = self, let gyroData = data else {
                    if let error = error {
                        print("Gyro update error: \(error.localizedDescription)")
                    }
                    return
                }
                self.processGyroData(gyroData)
            }
        }
    }

    private func startMagnetometerUpdates() {
        if motionManager.isMagnetometerAvailable {
            motionManager.magnetometerUpdateInterval = 0.1
            motionManager.startMagnetometerUpdates(to: OperationQueue.main) { [weak self] data, error in
                guard let self = self, let magnetometerData = data else {
                    if let error = error {
                        print("Magnetometer update error: \(error.localizedDescription)")
                    }
                    return
                }
                self.processMagnetometerData(magnetometerData)
            }
        }
    }

    private func processAccelerometerData(_ accelerometerData: CMAccelerometerData) {
        liveMotion.updateAccelerometerData(x: accelerometerData.acceleration.x,
                                           y: accelerometerData.acceleration.y,
                                           z: accelerometerData.acceleration.z)
        updateLiveMotion()
    }

    private func processGyroData(_ gyroData: CMGyroData) {
        liveMotion.updateGyroData(xTheta: gyroData.rotationRate.x,
                                  yTheta: gyroData.rotationRate.y,
                                  zTheta: gyroData.rotationRate.z)
        updateLiveMotion()
    }

    private func processMagnetometerData(_ magnetometerData: CMMagnetometerData) {
        liveMotion.updateMagnetometerData(xField: magnetometerData.magneticField.x,
                                          yField: magnetometerData.magneticField.y,
                                          zField: magnetometerData.magneticField.z)
        updateLiveMotion()
    }

    private func updateLiveMotion() {
        motionsManagerService.recordMotion(liveMotion)
        motionUpdateCount += 1

        // Optionally, save motions periodically or based on a condition
        if motionUpdateCount % 100 == 0 {
            let savedMotions = motionsManagerService.getCachedMotions()
            print("Cached motions: \(savedMotions)")
        }
    }
    #endif
}
