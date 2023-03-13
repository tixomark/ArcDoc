//
//  3DSceneView.swift
//  ArchdocApp
//
//  Created by tixomark on 2/11/23.
//

import Foundation
import SceneKit

class TriDSceneView: SCNView {
    
    private var mainNode: SCNNode!
    private var cameraNode: SCNNode!
    private var cameraInitialPosition: SCNVector3!
    var zNear: Double = 0
    var zFar: Double = 2000
    var minZoomDistance: Float = 400
    var maxZoomDistance: Float = 2000
    
    func setUpScene(usingAsset mdlAsset: MDLAsset) {
        self.scene = SCNScene(mdlAsset: mdlAsset)
        mainNode = self.scene?.rootNode.childNodes.first
        
        setUpLight()
        setUpCamera()
        addGestures()
    }
    
    deinit {
        print("deinit 'TriDSceneView'")
    }
    
    private func setUpLight() {
        let spotLight = SCNNode()
        spotLight.light = SCNLight()
        spotLight.light?.type = .directional
        self.scene?.rootNode.addChildNode(spotLight)
    }
    
    private func setUpCamera() {
        let mainCamera = SCNCamera()
        mainCamera.zNear = zNear
        mainCamera.zFar = zFar
        cameraNode = SCNNode()
        cameraNode.camera = mainCamera
        self.scene?.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 100, z: 600)
        cameraInitialPosition = cameraNode.position
    }
    
    private func addGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
        let tapAndPanPinchGesture = UITapAndPanGestureRecognizer(target: self, action: #selector(tapAndPanPinch(gesture:)))
        let translationGesture = UIPanGestureRecognizer(target: self, action: #selector(translation(gesture:)))
        translationGesture.minimumNumberOfTouches = 2
        let tapAndPanTranlationGesture = UITapAndPanGestureRecognizer(target: self, action: #selector(translation(gesture:)))
        tapAndPanTranlationGesture.numberOfTapsRequiredToInitiate = 2
        
        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(pinchGesture)
        self.addGestureRecognizer(tapAndPanPinchGesture)
        self.addGestureRecognizer(translationGesture)
        self.addGestureRecognizer(tapAndPanTranlationGesture)
    }
    
    @objc private func pan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        gesture.setTranslation(CGPoint(), in: self)
        let translationVector = simd_float2(x: Float(translation.x), y: Float(translation.y))
        rotate(mainNode, accordingTo: translationVector)
    }
    
    @objc private func pinch(gesture: UIPinchGestureRecognizer) {
        let velocity = Float(gesture.velocity)
        zoomCamera(accordingTo: velocity, minDistance: minZoomDistance, maxDistance: maxZoomDistance, withSpeed: 30)
    }
    
    @objc private func tapAndPanPinch(gesture: UITapAndPanGestureRecognizer) {
        let velocity = Float(gesture.velocity(in: self).y)
        zoomCamera(accordingTo: velocity, minDistance: minZoomDistance, maxDistance: maxZoomDistance, withSpeed: 0.3)
    }
    
    @objc private func translation(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        gesture.setTranslation(CGPoint(), in: self)
        let translationVector = simd_float2(x: Float(translation.x), y: Float(translation.y))
        translateCamera(accordingTo: translationVector, withSpeed: 8)
    }
    
    private func translateCamera(accordingTo value: simd_float2, withSpeed speed: Float) {
        let positionAdjustment = simd_float3(x: value.x * speed, y: -value.y * speed, z: 0)
        let newPosition = mainNode.simdPosition + positionAdjustment
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.1
        
        mainNode.simdPosition = newPosition
        
        SCNTransaction.commit()
    }
    
    private func zoomCamera(accordingTo value: Float, minDistance min: Float = 10, maxDistance max: Float = 100, withSpeed speed: Float = 10, duration: CFTimeInterval = 0.1) {
        let cameraPositionAdjustment = speed * -value
        var newCameraZPosition = cameraNode.position.z + cameraPositionAdjustment
        newCameraZPosition.clamp(min: min, max: max)
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        
        cameraNode.position.z = newCameraZPosition
        
        SCNTransaction.commit()
    }
    
    private func rotate(_ node: SCNNode, accordingTo vector: simd_float2) {
        let yAngle = GLKMathDegreesToRadians(1) * vector.y * 0.5
        let xAngle = GLKMathDegreesToRadians(1) * vector.x
        let yRotation = simd_quatf(angle: xAngle, axis: simd_float3(x: 0, y: 1, z: 0))
        var xRotation = simd_quatf(angle: yAngle, axis: simd_float3(x: 1, y: 0, z: 0))
        
        let currentAngleToZero = acos(node.simdWorldUp.z)
        var correctionAngle: Float = 0
        
        if yAngle < 0 && abs(yAngle) > (3.14 - currentAngleToZero) {
            correctionAngle = -yAngle - 3.14 + currentAngleToZero
        }
        if yAngle > 0 && yAngle > (currentAngleToZero - GLKMathDegreesToRadians(1)) {
            correctionAngle = currentAngleToZero - yAngle - GLKMathDegreesToRadians(1)
        }
        
        xRotation = xRotation * simd_quatf(angle: correctionAngle, axis: simd_float3(x: 1, y: 0, z: 0))
        
        guard let parentNode = node.parent else {return}
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.1
        
        node.simdLocalRotate(by: yRotation)
        node.simdRotate(by: xRotation, aroundTarget: parentNode.simdPosition)
        
        SCNTransaction.commit()
        //        node.simdOrientation = node.simdOrientation * yRotation
        //        node.simdOrientation = xRotation * node.simdOrientation
    }

}

extension TriDSceneView: TriDSceneProtocol {
    func returnToInitialState() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1
        
        cameraNode.position = cameraInitialPosition
        mainNode.orientation = SCNQuaternion(0, 0, 0, 1)
        mainNode.position = SCNVector3(x: 0, y: 0, z: 0)
        
        SCNTransaction.commit()
    }
        
    func zoom(_ isZooming: Bool) {
        let zoomParam: Float = isZooming ? 1 : -1
        zoomCamera(accordingTo: zoomParam, minDistance: minZoomDistance, maxDistance: maxZoomDistance, withSpeed: 200, duration: 0.5)
    }
    
}

extension Float {
    mutating func clamp(min: Float, max: Float){
        if self > max {
            self = max
        } else if self < min {
            self = min
        }
    }
}
