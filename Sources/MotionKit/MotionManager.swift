import Observation
#if !os(macOS)
import CoreMotion
#endif
@available(macOS 14.0, *)
@available(iOS 17.0, *)
@Observable public class MotionKit {
    public var liveMotion: LiveMotion = LiveMotion()
    #if !os(macOS)
    private var motionManager = CMMotionManager()
    #endif
    
    public init() {
        startAccelerometerUpdates()
    }
    
    func startAccelerometerUpdates() {
        #if !os(macOS)
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) {  data, error in
                if let accelerometerData = data {
                    DispatchQueue.main.async {[weak self] in
                        self?.liveMotion.x = accelerometerData.acceleration.x
                        self?.liveMotion.y =  accelerometerData.acceleration.y
                        self?.liveMotion.z =  accelerometerData.acceleration.z
                        
                    }
                }
            }
        }
        #endif
    }
}
