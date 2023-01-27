//
//  3DSceneViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 1/26/23.
//

import UIKit
import SceneKit

class TriDSceneViewController: UIViewController {
    
    var presenter: TriDScenePresenterProtocol?
    
    //    var topInvisible
    
    var sceneView: SCNView!
    var mainNode: SCNNode!
    
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
        let scene = SCNScene(named: "GirlsScene.scn")
        sceneView.scene = scene
        mainNode = sceneView.scene?.rootNode.childNode(withName: "Girls", recursively: false)
    }
    
    func addGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gesture:)))
        sceneView.addGestureRecognizer(panGesture)
    }
    
    @objc func panGesture(gesture: UIPanGestureRecognizer) {
        let transition = gesture.translation(in: sceneView)
        gesture.setTranslation(CGPoint(), in: sceneView)
        let transitionVector = simd_float2(x: Float(transition.x), y: Float(transition.y))
        
        rotate(mainNode, accordingTo: transitionVector)
    }
    
    func rotate(_ node: SCNNode, accordingTo vector: simd_float2) {
        
        var yAngle = GLKMathDegreesToRadians(2) * vector.y * 0.5
        let xAngle = GLKMathDegreesToRadians(2) * vector.x * 0.5
        yAngle.clamp(min: -0.4, max: 0.4)

        let yRotation = simd_quatf(angle: xAngle, axis: simd_float3(x: 0, y: 1, z: 0))
        let xRotation = simd_quatf(angle: yAngle, axis: simd_float3(x: 1, y: 0, z: 0))
        
        // clculate final rotation after xRotation will be applied
        let orientetionAfterPossibleXRotationIsPerformed = xRotation * node.simdOrientation
        // apply final rotation quaternion to unit Y vector. Check if >= 0 to allow xRotation to be applied
        let rotationPossibilityCheck = orientetionAfterPossibleXRotationIsPerformed.act(simd_float3(x: 0, y: 1, z: 0)).y >= 0
        
        guard let parentNode = node.parent else {return}
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.1
        
        node.simdLocalRotate(by: yRotation)
        if rotationPossibilityCheck {
            node.simdRotate(by: xRotation, aroundTarget: parentNode.simdPosition)
        }
        SCNTransaction.commit()
//        node.simdOrientation = node.simdOrientation * yRotation
//        node.simdOrientation = xRotation * node.simdOrientation
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
