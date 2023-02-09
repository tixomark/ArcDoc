//
//  3DSceneViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 1/26/23.
//

import UIKit
import SceneKit
import SceneKit.ModelIO

class TriDSceneViewController: UIViewController {
    
    var presenter: TriDScenePresenterProtocol!
    
    var sceneView: SCNView!
    var mainNode: SCNNode!
    var cameraNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpScene()
        addGestures()
        
    }
    
    func setUpUI() {
        view.backgroundColor = .systemBackground
        sceneView = SCNView()
        view.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    func setUpScene() {
        let modelAsset = MDLAsset(url: presenter.modelUrl)
        let scene = SCNScene(mdlAsset: modelAsset)
        sceneView.scene = scene
        
        mainNode = sceneView.scene?.rootNode.childNodes.first
        print(mainNode.position)

        setUpLight()
        setUpCamera()
    }
    
    func setUpLight() {
        let spotLight = SCNNode()
        spotLight.light = SCNLight()
        spotLight.light?.type = .directional
        sceneView.scene?.rootNode.addChildNode(spotLight)
    }
    
    func setUpCamera() {
        let mainCamera = SCNCamera()
        mainCamera.zNear = 0
        mainCamera.zFar = 2000
        cameraNode = SCNNode()
        cameraNode.camera = mainCamera
        sceneView.scene?.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 100, z: 600)
    }
    
    func addGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
        let tapAndPanPinchGesture = UITapAndPanGestureRecognizer(target: self, action: #selector(tapAndPanPinch(gesture:)))
        let translationGesture = UIPanGestureRecognizer(target: self, action: #selector(translation(gesture:)))
        translationGesture.minimumNumberOfTouches = 2
        let tapAndPanTranlationGesture = UITapAndPanGestureRecognizer(target: self, action: #selector(translation(gesture:)))
        tapAndPanTranlationGesture.numberOfTapsRequiredToInitiate = 2
        
        sceneView.addGestureRecognizer(pinchGesture)
        sceneView.addGestureRecognizer(panGesture)
        sceneView.addGestureRecognizer(tapAndPanPinchGesture)
        sceneView.addGestureRecognizer(translationGesture)
        sceneView.addGestureRecognizer(tapAndPanTranlationGesture)
        
    }
    
    @objc private func pan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: sceneView)
        gesture.setTranslation(CGPoint(), in: sceneView)
        let translationVector = simd_float2(x: Float(translation.x), y: Float(translation.y))
        rotate(mainNode, accordingTo: translationVector)
    }
    
    @objc private func pinch(gesture: UIPinchGestureRecognizer) {
        let velocity = Float(gesture.velocity)
        zoomCamera(accordingTo: velocity, minDistance: 400, maxDistance: 2000, withSpeed: 30)
    }
    
    @objc private func tapAndPanPinch(gesture: UITapAndPanGestureRecognizer) {
        let velocity = Float(gesture.velocity(in: sceneView).y)
        zoomCamera(accordingTo: velocity, minDistance: 400, maxDistance: 2000, withSpeed: 0.3)
    }
    
    @objc private func translation(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: sceneView)
        gesture.setTranslation(CGPoint(), in: sceneView)
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
    
    private func zoomCamera(accordingTo value: Float, minDistance min: Float = 10, maxDistance max: Float = 10, withSpeed speed: Float = 10) {
        let cameraPositionAdjustment = speed * -value
        var newCameraZPosition = cameraNode.position.z + cameraPositionAdjustment
        newCameraZPosition.clamp(min: min, max: max)
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.1
        
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
    
    deinit {
        print("deinit TriDSceneViewController")
    }
}

extension TriDSceneViewController: TriDSceneViewProtocol {
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
