package dev.pam.threed
import android.content.Context
import android.view.Choreographer
import android.view.MotionEvent
import android.view.SurfaceView
import android.view.View
import com.google.android.filament.Renderer
import com.google.android.filament.utils.ModelViewer
import com.google.android.filament.utils.Utils
import dev.pam.nativeapp.protocol.WireMap
import dev.pam.nativeapp.protocol.WireValue
import dev.pam.nativeapp.views.NativeViewFactory
import java.io.File
import java.nio.ByteBuffer
import org.json.JSONObject

class SceneViewFactory(private val context:Context):NativeViewFactory{
 init{Utils.init()}
 override fun create(context:Context,emit:(ByteArray)->Unit):View=PamSceneView(context,emit)
 override fun update(view:View,properties:Map<String,WireValue>)=(view as PamSceneView).update(properties)
 override fun release(view:View)=(view as PamSceneView).releaseScene()
}
private class PamSceneView(context:Context,private val emit:(ByteArray)->Unit):SurfaceView(context),Choreographer.FrameCallback{
 private val root=context.applicationContext.filesDir.canonicalFile;private val viewer=ModelViewer(this);private var revision=-1L;private var controls=2L;private var running=true
 init{Choreographer.getInstance().postFrameCallback(this);send(1)}
 fun update(values:Map<String,WireValue>){controls=(values["controls"]as?WireValue.Integer)?.value?:2;applyBackground((values["background"]as?WireValue.Text)?.value?:"#10131aff");val next=(values["revision"]as?WireValue.Integer)?.value?:0;if(next==revision)return;revision=next;val json=(values["asset"]as?WireValue.Text)?.value?:return;runCatching{load(JSONObject(json))}.onFailure{send(4,it.message.orEmpty())}}
 private fun load(asset:JSONObject){val file=file(asset.getString("androidGlb"));val bytes=file.inputStream().channel.use{channel->channel.map(java.nio.channels.FileChannel.MapMode.READ_ONLY,0,channel.size())};viewer.loadModelGlb(bytes);viewer.transformToUnitCube();viewer.autoPlayAnimations=true;viewer.activeAnimationIndex=asset.optInt("animation",0);viewer.asset?.let{model->val manager=viewer.engine.transformManager;val instance=manager.getInstance(model.root);val s=asset.optDouble("scale",1.0).toFloat();val x=asset.optDouble("x",0.0).toFloat();val y=asset.optDouble("y",0.0).toFloat();val z=asset.optDouble("z",0.0).toFloat();manager.setTransform(instance,floatArrayOf(s,0f,0f,0f,0f,s,0f,0f,0f,0f,s,0f,x,y,z,1f))};send(2)}
 override fun doFrame(frameTimeNanos:Long){if(!running)return;viewer.render(frameTimeNanos);Choreographer.getInstance().postFrameCallback(this)}
 override fun onTouchEvent(event:MotionEvent):Boolean{if(controls==2L)viewer.onTouchEvent(event);if(event.actionMasked==MotionEvent.ACTION_UP)send(3);return controls==2L}
	 private fun applyBackground(hex:String){val color=runCatching{android.graphics.Color.parseColor(hex)}.getOrDefault(android.graphics.Color.BLACK);viewer.renderer.clearOptions=Renderer.ClearOptions().apply{clear=true;clearColor=doubleArrayOf(android.graphics.Color.red(color)/255.0,android.graphics.Color.green(color)/255.0,android.graphics.Color.blue(color)/255.0,android.graphics.Color.alpha(color)/255.0)}}
 private fun file(path:String):File{val target=File(root,path).canonicalFile;require(target.path.startsWith(root.path+File.separator)&&target.isFile){"3D asset is outside the sandbox or missing"};return target}
 fun releaseScene(){running=false;Choreographer.getInstance().removeFrameCallback(this);viewer.destroy()}
 private fun send(event:Long,message:String="")=emit(WireMap.encode(mapOf("event" to WireValue.Integer(event),"message" to WireValue.Text(message))))
}
