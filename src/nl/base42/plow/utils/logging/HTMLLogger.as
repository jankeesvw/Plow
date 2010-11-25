package nl.base42.plow.utils.logging {
	import flash.events.EventDispatcher;
	import logmeister.connectors.ILogMeisterConnector;
	import nl.base42.plow.utils.StringUtils;

	/**
	 * @author jankees [at] base42.nl
	 */
	public class HTMLLogger extends EventDispatcher implements ILogMeisterConnector {
		private static const color_debug : String = "#a6e22e";
		private static const color_info : String = "#66d9ef";
		private static const color_notice : String = "#ae81ff";
		private static const color_warning : String = "#fd971f";
		private static const color_error : String = "#FF0A0A";
		private static const color_fatal : String = "#FF8000";
		private static const color_critical : String = "#f92672";
		private static const color_status : String = "#33FF00";

		public function init() : void {
		}

		public function sendInfo(...args : *) : void {
			dispatchEvent(new HTMLLoggerEvent(HTMLLoggerEvent.SEND, makePretty(color_info,args)));
		}

		public function sendError(...args : *) : void {
			dispatchEvent(new HTMLLoggerEvent(HTMLLoggerEvent.SEND, makePretty(color_error,args)));
		}

		public function sendCritical(...args : *) : void {
			dispatchEvent(new HTMLLoggerEvent(HTMLLoggerEvent.SEND, makePretty(color_critical,args)));
		}

		public function sendStatus(...args : *) : void {
			dispatchEvent(new HTMLLoggerEvent(HTMLLoggerEvent.SEND, makePretty(color_status,args)));
		}

		public function sendDebug(...args : *) : void {
			dispatchEvent(new HTMLLoggerEvent(HTMLLoggerEvent.SEND, makePretty(color_debug,args)));
		}

		public function sendFatal(...args : *) : void {
			dispatchEvent(new HTMLLoggerEvent(HTMLLoggerEvent.SEND, makePretty(color_fatal,args)));
		}

		public function sendWarn(...args : *) : void {
			dispatchEvent(new HTMLLoggerEvent(HTMLLoggerEvent.SEND, makePretty(color_warning,args)));
		}

		public function sendNotice(...args : *) : void {
			dispatchEvent(new HTMLLoggerEvent(HTMLLoggerEvent.SEND, makePretty(color_notice,args)));
		}

		private function makePretty(color : String, ...args : *) : String {
			var str : String = "<font style='font-size: 9px; color: " + color + "'>" + String(args);
			str = StringUtils.replace(str, "\n", "<br>");
			return str + "<br>";
		}
	}
}
