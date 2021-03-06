package haxeserver.process;

import haxe.io.Bytes;

interface IHaxeServerProcess {
	function close(graceful:Bool = true, ?callback:() -> Void):Void;
	function isAsynchronous():Bool;
	function request(arguments:Array<String>, ?stdin:Bytes, callback:HaxeServerRequestResult->Void, errback:String->Void):Void;
}
