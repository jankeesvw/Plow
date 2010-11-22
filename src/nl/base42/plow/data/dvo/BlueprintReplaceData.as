package nl.base42.plow.data.dvo {
	import nl.base42.plow.utils.IParsable;

	/**
	 * @author jankees [at] base42.nl
	 */
	public class BlueprintReplaceData implements IParsable {
		public var fieldname : String;
		public var replace : String;
		public var text : String;
		//
		private var defaultValue : String;

		public function parseXML(o : XML) : void {
			fieldname = o.@fieldname;
			replace = o.@replace;
			defaultValue = o.@default;
			text = defaultValue;
		}
	}
}