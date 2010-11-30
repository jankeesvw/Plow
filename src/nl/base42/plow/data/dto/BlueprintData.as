package nl.base42.plow.data.dto {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	import nl.base42.plow.data.PlowDatabaseConnection;
	import nl.base42.plow.utils.ObjectTracer;
	import nl.base42.plow.utils.parser.Parser;

	/**
	 * @author jankees [at] base42.nl
	 */
	public class BlueprintData {
		public static const DATABASE_ID_FIELD : String = "id";
		public static const DATABASE_NAME_FIELD : String = "name";
		public static const DATABASE_PATH_FIELD : String = "path";
		//
		public static const PLOW_BLUEPRINT_FILE : String = "plow.xml";
		//
		public var name : String;
		public var path : String;
		public var id : uint;
		private var _replaceFields : Array;

		public function parseFromDatabase(result : Object) : Boolean {
			id = result[DATABASE_ID_FIELD];
			name = result[DATABASE_NAME_FIELD];
			path = result[DATABASE_PATH_FIELD];

			reloadXML();

			checkForName();

			return new File(path).exists;
		}

		public function parseFromFile(inDirectory : File) : void {
			name = inDirectory.name;
			path = inDirectory.nativePath;

			reloadXML();

			checkForName();
		}

		private function checkForName() : void {
			if (hasPlowConfigFile()) {
				if (reloadXML().attribute("name").length()) {
					name = reloadXML().@name;
				}
			}
		}

		public function toObject() : Object {
			return {id:id, name:name, path:path};
		}

		public function getPlowReplaceFields() : Array {
			return _replaceFields;
		}

		private function reloadXML() : XML {
			if (hasPlowConfigFile()) {
				var file : File = plowConfigFile();
				var fileStream : FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				var xml : XML = XML(fileStream.readMultiByte(file.size, File.systemCharset));
				fileStream.close();
				_replaceFields = Parser.parseList(xml.child("replaces").child("replace"), BlueprintReplaceData);
			} else {
				_replaceFields = [];
			}

			return xml;
		}

		public function toString() : String {
			// nl.base42.plow.data.dvo.BlueprintData
			return ObjectTracer.trace(this);
		}

		public function toInsertSQL() : String {
			return "INSERT INTO " + PlowDatabaseConnection.BLUEPRINT_TABLE_NAME + " (" + DATABASE_NAME_FIELD + ", " + DATABASE_PATH_FIELD + ") " + "VALUES ('" + name + "', '" + path + "')";
		}

		public function toDeleteSQL() : String {
			return "DELETE FROM " + PlowDatabaseConnection.BLUEPRINT_TABLE_NAME + " WHERE " + DATABASE_ID_FIELD + " = '" + id + "'";
		}

		public function hasPlowConfigFile() : Boolean {
			var blueprintfile : File = plowConfigFile();
			return blueprintfile.exists;
		}

		public function plowConfigFile() : File {
			return new File(path + File.separator + PLOW_BLUEPRINT_FILE);
		}
	}
}
