package haxeserver;

import haxe.io.Bytes;
import haxeserver.process.IHaxeServerProcess;

/**
	`HaxeServerAsync` is one level above `IHaxeServerProcess` and manages communication with it.

	Its request methods accept a `callback` argument that is called upon completing the request. This
	works with bost synchronous and asynchronous processes.

**/
class HaxeServerAsync extends HaxeServerBase {
	/**
		Creates a new `HaxeServerAsync` which executes `createProcess` upon starting.

		Starts automatically.
	**/
	public function new(createProcess:Void->IHaxeServerProcess) {
		super(createProcess, true);
	}

	/**
		Sends a raw request to the process, using the provided `arguments` and calls `callback` upon completion.

		If `stdin` is not `null`, it is passed to the process and the argument list
		is expanded by `-D display-stdin`.
	**/
	public function rawRequest(arguments:Array<String>, ?stdin:Bytes, callback:HaxeServerRequestResult->Void, errback:String->Void) {
		arguments = defaultRequestArguments.concat(arguments);
		if (stdin != null) {
			arguments = arguments.concat(["-D", "display-stdin"]);
		}
		process.request(arguments, stdin, callback, errback);
	}

	/**
		Convenience function to launch a new `HaxeServerAsync` instance with the given `command`
		and `arguments`.

		Uses `HaxeServerProcessSys` on `sys` targets and `HaxeServerProcessNode` if `nodejs` is available.

		Fails in other situations.
	**/
	static public function launch(command:String, arguments:Array<String>) {
		#if nodejs
		var f = () -> new haxeserver.process.HaxeServerProcessNode(command, arguments);
		#elseif sys
		var f = () -> new haxeserver.process.HaxeServerProcessSys(command, arguments);
		#else
		throw "No haxeserver.process class available on this target";
		#end
		return new HaxeServerAsync(f);
	}
}
