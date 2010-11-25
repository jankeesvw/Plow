package nl.base42.plow.data.dvo {
	import nl.base42.plow.data.PlowDatabaseConnection;
	import nl.base42.plow.utils.ObjectTracer;
	import nl.base42.plow.utils.Parser;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

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

		public function parseFromDatabase(result : Object) : Boolean {
			id = result[DATABASE_ID_FIELD];
			name = result[DATABASE_NAME_FIELD];
			path = result[DATABASE_PATH_FIELD];

			checkForName();
			
			return new File(path).exists;
		}

		public function parseFromFile(inDirectory : File) : void {
			name = inDirectory.name;
			path = inDirectory.nativePath;

			checkForName();
		}

		private function checkForName() : void {
			if (hasPlowConfigFile()) {
				if (getXML().attribute("name").length()) {
					name = getXML().@name;
				}
			}
		}

		public function toObject() : Object {
			return {id:id, name:name, path:path};
		}

		public function getPlowReplaceFields() : Array {
			// return empty array if there is no config file
			if (!hasPlowConfigFile()) return [];

			return Parser.parseList(getXML().replaces.replace, BlueprintReplaceData);
		}

		private function getXML() : XML {
			var file : File = plowConfigFile();
			var fileStream : FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var xml : XML = XML(fileStream.readMultiByte(file.size, File.systemCharset));
			fileStream.close();
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
