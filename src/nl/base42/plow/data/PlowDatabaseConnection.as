package nl.base42.plow.data {
	import nl.base42.plow.data.dvo.BlueprintData;

	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SQLEvent;
	import flash.filesystem.File;

	/**
	 * @author jankees [at] base42.nl
	 */
	[Event(name="Event.CHANGE", type="flash.events.Event")]
	public class PlowDatabaseConnection extends EventDispatcher {
		public static const DATABASE_NAME : String = "plow.db";
		public static const BLUEPRINT_TABLE_NAME : String = "blueprints";
		//
		private var _connection : SQLConnection;
		private var _blueprints : Array;

		public function PlowDatabaseConnection() {
			_connection = new SQLConnection();
			_connection.addEventListener(SQLEvent.OPEN, openHandler);
			_connection.openAsync(File.applicationDirectory.resolvePath(DATABASE_NAME));
		}

		private function openHandler(event : SQLEvent) : void {
			status("Plow database opened from: " + File.applicationDirectory.resolvePath(DATABASE_NAME).nativePath);

			/** create tables if needed */
			var sql : SQLStatement = new SQLStatement();
			sql.sqlConnection = _connection;
			sql.text = "CREATE TABLE IF NOT EXISTS " + BLUEPRINT_TABLE_NAME + " (id INTEGER PRIMARY KEY AUTOINCREMENT, " + BlueprintData.DATABASE_NAME_FIELD + " TEXT, " + BlueprintData.DATABASE_PATH_FIELD + " TEXT)";
			sql.addEventListener(SQLEvent.RESULT, retrieveDataFromDatabase);
			sql.execute();
		}

		private function retrieveDataFromDatabase(event : SQLEvent = null) : void {
			var sql : SQLStatement = new SQLStatement();
			sql.sqlConnection = _connection;
			sql.text = "SELECT * FROM " + BLUEPRINT_TABLE_NAME;
			sql.addEventListener(SQLEvent.RESULT, handleRetrieveDataFromDatabase);
			sql.execute();
		}

		private function handleRetrieveDataFromDatabase(event : SQLEvent) : void {
			_blueprints = [];
			var results : Array = SQLStatement(event.target).getResult().data;
			if (results) {
				for each (var result : Object in results) {
					var d : BlueprintData = new BlueprintData();
					d.parseFromDatabase(result);
					_blueprints.push(d);
				}
			} else {
				status("database is empty");
			}
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function getBlueprints() : Array {
			return _blueprints;
		}

		public function saveNewItem(d : BlueprintData) : void {
			var sql : SQLStatement = new SQLStatement();
			sql.sqlConnection = _connection;
			sql.text = d.toInsertSQL();
			debug("saveNewItem: sql.text: " + (sql.text));
			sql.addEventListener(SQLEvent.RESULT, handleSave);
			sql.execute();
		}

		private function handleSave(event : SQLEvent) : void {
			retrieveDataFromDatabase();
		}
	}
}
