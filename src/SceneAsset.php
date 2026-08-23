<?php
declare(strict_types=1);
namespace Pam\Native\ThreeD;
use InvalidArgumentException;
final readonly class SceneAsset
{
 public function __construct(public string$androidGlb,public string$iosUsdz,public float$scale=1,public float$x=0,public float$y=0,public float$z=0,public int$animation=0,public bool$loopAnimation=true){foreach([$androidGlb,$iosUsdz]as$path)self::assertPath($path);foreach([$scale,$x,$y,$z]as$value)if(!is_finite($value))throw new InvalidArgumentException('3D transforms must be finite.');if($scale<=0||$scale>10_000||$animation<0)throw new InvalidArgumentException('3D scale or animation index is invalid.');}
 /** @return array<string,string|float|int|bool> */public function toArray():array{return['androidGlb'=>$this->androidGlb,'iosUsdz'=>$this->iosUsdz,'scale'=>$this->scale,'x'=>$this->x,'y'=>$this->y,'z'=>$this->z,'animation'=>$this->animation,'loopAnimation'=>$this->loopAnimation];}
 private static function assertPath(string$path):void{$segments=preg_split('~[/\\\\]+~',$path);if($path===''||strlen($path)>1024||str_contains($path,"\0")||str_starts_with($path,'/')||str_contains($path,'://')||$segments===false||in_array('..',$segments,true))throw new InvalidArgumentException('3D assets must use relative sandbox paths.');}
}
