package nl.base42.plow.utils {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author jankees [at] base42.nl
	 */
	public class HTMLLoggerEvent extends Event {
		public static const SEND : String = "HTMLLoggerEvent.SEND";
		//
		// public properties:
		public var message : String;
		
		public function HTMLLoggerEvent(inType : String, inMessage : String) {
			message = inMessage;
			super(inType, true);
		}
		
		override public function clone():Event {
			var c:HTMLLoggerEvent = new HTMLLoggerEvent(type,message);
			return c;
		}
		
		override public function toString():String {
			// nl.base42.plow.utils.HTMLLoggerEvent
			return getQualifiedClassName(this);
		}
	}
}
