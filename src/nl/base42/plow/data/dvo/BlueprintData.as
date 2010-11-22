package nl.base42.plow.data.dvo {
	import nl.base42.plow.data.PlowDatabaseConnection;
	import nl.base42.plow.utils.ObjectTracer;

	import flash.filesystem.File;

	/**
	 * @author jankees [at] base42.nl
	 */
	public class BlueprintData {
		public static const DATABASE_NAME_FIELD : String = "name";
		public static const DATABASE_PATH_FIELD : String = "path";
		public var name : String;
		public var path : String;

		public function parseFromDatabase(result : Object) : void {
			name = result[DATABASE_NAME_FIELD];
			path = result[DATABASE_PATH_FIELD];
		}

		public function parseFromFile(inDirectory : File) : void {
			name = inDirectory.name;
			path = inDirectory.nativePath;
		}

		public function toObject() : Object {
			return {name:name, path:path};
		}

		public function toString() : String {
			// nl.base42.plow.data.dvo.BlueprintData
			return ObjectTracer.trace(this);
		}

		public function toInsertSQL() : String {
			return "INSERT INTO " + PlowDatabaseConnection.BLUEPRINT_TABLE_NAME + " (" + DATABASE_NAME_FIELD + ", " + DATABASE_PATH_FIELD + ") " + "VALUES ('" + name + "', '" + path + "')";
		}
	}
}
