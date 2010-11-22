package nl.base42.plow.data.dvo {
	import nl.base42.plow.data.PlowDatabaseConnection;
	import nl.base42.plow.utils.ObjectTracer;

	import flash.filesystem.File;

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
		public var plowFileExists : Boolean;

		public function parseFromDatabase(result : Object) : Boolean {
			id = result[DATABASE_ID_FIELD];
			name = result[DATABASE_NAME_FIELD];
			path = result[DATABASE_PATH_FIELD];

			return new File(path).exists;
		}

		public function parseFromFile(inDirectory : File) : void {
			name = inDirectory.name;
			path = inDirectory.nativePath;

			var blueprintfile : File = new File(path + File.separator + PLOW_BLUEPRINT_FILE);
			plowFileExists = blueprintfile.exists;
		}

		public function toObject() : Object {
			return {id:id, name:name, path:path};
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
	}
}
