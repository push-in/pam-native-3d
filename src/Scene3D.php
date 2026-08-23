<?php
declare(strict_types=1);
namespace Pam\Native\ThreeD;
use Closure;use JsonException;use Pam\Native\Element;use Pam\Native\Internal\Wire;use Pam\Native\Renderable;use Pam\Native\UI\CustomView;
final class Scene3D implements Renderable
{
 private ?Closure$handler=null;private function __construct(private readonly SceneAsset$asset,private readonly SceneControlMode$controls,private readonly string$background,private readonly int$revision){}
 public static function make(SceneAsset$asset,SceneControlMode$controls=SceneControlMode::Orbit,string$background='#10131aff',int$revision=1):self{return new self($asset,$controls,$background,max(0,$revision));}
 /** @param Closure(SceneEventKind,string):void $handler */public function onEvent(Closure$handler):self{$copy=clone$this;$copy->handler=$handler;return$copy;}
 /** @throws JsonException */public function toElement():Element{$json=json_encode($this->asset->toArray(),JSON_THROW_ON_ERROR|JSON_UNESCAPED_SLASHES);$view=CustomView::make('three-d.scene',['asset'=>$json,'controls'=>$this->controls->value,'background'=>$this->background,'revision'=>$this->revision]);$handler=$this->handler;return$handler===null?$view:$view->onNativeEvent(static function(string$payload)use($handler):void{$v=Wire::decodeMap($payload);$kind=SceneEventKind::tryFrom((int)($v['event']??4))??SceneEventKind::Error;$handler($kind,(string)($v['message']??''));});}
}
