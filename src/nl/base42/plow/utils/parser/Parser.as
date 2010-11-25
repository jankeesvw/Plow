package nl.base42.plow.utils.parser {
	public class Parser {
		public static function parseList(inList : XMLList, inClass : Class) : Array {
			var a : Array = [];
			var len : Number = inList.length();
			for (var i : Number = 0; i < len; i++) {
				var ipa : IParsable = parseXML(inList[i], inClass);
				a.push(ipa);
			}
			return a;
		}

		public static function parseXML(inXML : XML, inClass : Class) : IParsable {
			var ipa : IParsable = new inClass();
			ipa.parseXML(inXML);
			return ipa;
		}
	}
}
