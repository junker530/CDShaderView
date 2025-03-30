//
//  MotionManager.swift
//  CDShaderView
//
//  Created by Shota Sakoda on 2025/03/30.
//

import SwiftUI
import CoreMotion

final class MotionManager: ObservableObject {
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    private var manager: CMMotionManager
    private var referencePitch: Double = 0.0
    private var referenceRoll: Double = 0.0
    
    init() {
        self.manager = CMMotionManager()
        self.manager.deviceMotionUpdateInterval = 1/60
        self.manager.startDeviceMotionUpdates(to: .main) { [weak self] (motionData, error) in
            guard error == nil else {
                print(error!)
                return
            }
            if let motionData = motionData {
                let pitch = motionData.attitude.pitch
                let roll = motionData.attitude.roll
                self?.pitch = pitch - (self?.referencePitch ?? 0)
                self?.roll = roll - (self?.referenceRoll ?? 0)
            }
        }
    }
    
    func resetReference() {
        if let motionData = manager.deviceMotion {
            referencePitch = motionData.attitude.pitch
            referenceRoll = motionData.attitude.roll
        }
    }
}
