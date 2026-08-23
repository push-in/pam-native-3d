import Foundation
import PamNative
import RealityKit
import UIKit
public final class SceneViewFactory:NativeViewFactory,@unchecked Sendable{public init(){};public func create(context:AnyObject?,emit:@escaping(Data)->Void)->UIView{PamSceneView(emit:emit)};public func update(view:UIView,properties:[String:WireValue]){(view as?PamSceneView)?.update(properties)};public func release(view:UIView){(view as?PamSceneView)?.releaseScene()}}
private final class PamSceneView:ARView,@unchecked Sendable{
 private let emitter:(Data)->Void;private let root=FileManager.default.urls(for:.applicationSupportDirectory,in:.userDomainMask)[0].standardizedFileURL;private var revision:Int64 = -1;private var installedGestures:[EntityGestureRecognizer]=[]
 init(emit:@escaping(Data)->Void){emitter=emit;super.init(frame:.zero,cameraMode:.nonAR,automaticallyConfigureSession:false);environment.background = .color(.black);send(1)}
 @MainActor @preconcurrency required dynamic init(frame frameRect:CGRect){emitter={_ in};super.init(frame:frameRect,cameraMode:.nonAR,automaticallyConfigureSession:false);environment.background = .color(.black)}
 @MainActor @preconcurrency required dynamic init?(coder:NSCoder){nil}
 func update(_ values:[String:WireValue]){if case let.text(hex)?=values["background"]{environment.background = .color(color(hex))};guard case let.integer(next)?=values["revision"],next != revision,case let.text(json)?=values["asset"],let data=json.data(using:.utf8),let asset=try?JSONSerialization.jsonObject(with:data)as?[String:Any]else{return};revision=next;do{try load(asset,controls:values.integer("controls",2))}catch{send(4,error.localizedDescription)}}
 private func load(_ value:[String:Any],controls:Int64)throws{
  guard let path=value["iosUsdz"]as?String else{throw SceneError.invalidAsset}
  let url=try file(path);scene.anchors.removeAll()
  let entity=try Entity.load(contentsOf:url)
  let container=ModelEntity()
  container.addChild(entity)
  let scale=Float(value["scale"]as?Double ?? 1)
  container.scale=SIMD3(repeating:scale)
  container.position=SIMD3(Float(value["x"]as?Double ?? 0),Float(value["y"]as?Double ?? 0),Float(value["z"]as?Double ?? 0))
  let anchor=AnchorEntity(world:.zero);anchor.addChild(container);scene.addAnchor(anchor)
  installedGestures.forEach(removeGestureRecognizer);installedGestures=[]
  if controls==2{container.generateCollisionShapes(recursive:true);installedGestures=installGestures([.rotation,.scale,.translation],for:container)}
  let index=value["animation"]as?Int ?? 0
  if entity.availableAnimations.indices.contains(index){entity.playAnimation(entity.availableAnimations[index].repeat())}
  send(2)
 }
 private func file(_ path:String)throws->URL{let target=root.appendingPathComponent(path).standardizedFileURL;guard target.path.hasPrefix(root.path+"/"),FileManager.default.fileExists(atPath:target.path)else{throw SceneError.invalidAsset};return target}
 func releaseScene(){scene.anchors.removeAll();installedGestures.forEach(removeGestureRecognizer);installedGestures=[]}
 private func send(_ event:Int64,_ message:String=""){if let data=try?WireMap.encode(["event":.integer(event),"message":.text(message)]){emitter(data)}}
 private func color(_ hex:String)->UIColor{var value=hex;if value.hasPrefix("#"){value.removeFirst()};guard value.count==6||value.count==8,var number=UInt64(value,radix:16)else{return.black};if value.count==6{number=(number<<8)|255};return UIColor(red:CGFloat((number>>24)&255)/255,green:CGFloat((number>>16)&255)/255,blue:CGFloat((number>>8)&255)/255,alpha:CGFloat(number&255)/255)}
}
private enum SceneError:LocalizedError{case invalidAsset;var errorDescription:String?{"The RealityKit USDZ asset is missing or invalid."}}
private extension Dictionary where Key==String,Value==WireValue{func integer(_ key:String,_ fallback:Int64)->Int64{if case let.integer(value)?=self[key]{return value};return fallback}}
