package nl.base42.plow.data {
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import nl.base42.plow.data.dto.BlueprintData;

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
			_connection.openAsync(File.applicationStorageDirectory.resolvePath(DATABASE_NAME));
		}

		private function openHandler(event : SQLEvent) : void {
			status("Plow database opened from: " + File.applicationDirectory.resolvePath(DATABASE_NAME).nativePath);

			/** create tables if needed */
			var sql : SQLStatement = new SQLStatement();
			sql.sqlConnection = _connection;
			sql.text = "CREATE TABLE IF NOT EXISTS " + BLUEPRINT_TABLE_NAME + " (" + BlueprintData.DATABASE_ID_FIELD + " INTEGER PRIMARY KEY AUTOINCREMENT, " + BlueprintData.DATABASE_NAME_FIELD + " TEXT, " + BlueprintData.DATABASE_PATH_FIELD + " TEXT)";
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
					if (d.parseFromDatabase(result)) {
						// true if folder exists
						_blueprints.push(d);
					} else {
						// delete folder from database if it doesn't exists
						var sql : SQLStatement = new SQLStatement();
						sql.sqlConnection = _connection;
						sql.text = d.toDeleteSQL();
						sql.execute();
					}
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
			sql.addEventListener(SQLEvent.RESULT, handleSave);
			sql.execute();
		}

		public function deleteItem(d : BlueprintData) : void {
			var sql : SQLStatement = new SQLStatement();
			sql.sqlConnection = _connection;
			sql.text = d.toDeleteSQL();
			sql.addEventListener(SQLEvent.RESULT, handleSave);
			sql.execute();
		}

		private function handleSave(event : SQLEvent) : void {
			retrieveDataFromDatabase();
		}
	}
}
