//
//  ViewController.swift
//  SeekerAR
//
//  Created by 山下　耀崇 on 2018/10/23.
//  Copyright © 2018年 山下　耀崇. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        //特徴点を検出している様子が観れる
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        let scene = SCNScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //2D画像認識
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) else{
            fatalError("Missing expected asset catalog ressources.")
        }
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        //平面検出
        configuration.planeDetection = [.vertical, .horizontal]
        configuration.detectionImages = referenceImages
        
        // Run the view's session
        sceneView.session.run(configuration)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //tapaction
    @IBAction func tapp(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: sceneView)
        //.existingPlaneUsingExtent()から.featurePoint(特徴点検出)に変えた.
        let results = sceneView.hitTest(tapPoint, types: .featurePoint)
        let hitpoint = results.first
        
        //取得した座標を SCNNode の position に再設定し、ノードを移動させるelse {
        
        let point = SCNVector3.init(hitpoint!.worldTransform.columns.3.x,
                                    hitpoint!.worldTransform.columns.3.y,
                                    hitpoint!.worldTransform.columns.3.z)
        print("\(tapPoint)")
        
    }
  
 
    
    
    
   /* func readPeachNode(resource:String, node_name:String) -> SCNNode
    {
        //バンドルのパスを取得
        guard let url = Bundle.main.url(forResource: resource, withExtension: "dae") else {
            fatalError("invalid resource path")
        }
        
        //daeを別のシーンとして読み込む，読み込んだ時点では表示されない
        let scene_source = SCNSceneSource(url:url, options:nil)
        guard let peach_scene = scene_source?.scene(options: nil) else {
            //読み込み失敗
            fatalError("daeファイル読み込み失敗")
        }
        
        //読み込んだシーンから必要なノードを取り出す
        return peach_scene.rootNode.childNode(withName: node_name, recursively: true)!
    }
 */
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            
            if let peachScene = SCNScene(named: "art.scnassets/PEACH.scn"){
                if let peachNode = peachScene.rootNode.childNodes.first{
                    peachNode.eulerAngles.x = .pi / 2
                    peachNode.eulerAngles.z = .pi
                    planeNode.addChildNode(peachNode)
                    
                }
            }
            //位置の変更
            node.simdTransform = imageAnchor.transform
            //回転の変更
            node.eulerAngles.x = 0
        }
      /*
         //読み込んだ時にファイル名をアプリに表示
         DispatchQueue.main.async {
            let imageName = .name ?? ""
            self.statusViewController.cancelAllScheduledMessages()
            self.statusViewController.showMessage("Detected image “\(imageName)”")
        }
 */
       
         return node
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
