package nl.base42.plow.utils.parser {

	public interface IParsable {
		/**
		*	Parse an object from XML into typed variables.
		*	@param o: XML containing data
		*	@return true if parsing went ok, otherwise false
		*/
		function parseXML(o:XML) : void;
	}
}
