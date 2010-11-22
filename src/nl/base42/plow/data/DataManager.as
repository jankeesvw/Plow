package nl.base42.plow.data {
	import nl.base42.plow.data.dvo.BlueprintData;

	import mx.collections.ArrayCollection;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;

	/**
	 * @author jankees [at] base42.nl
	 */
	public class DataManager extends EventDispatcher {
		private static const INSTANCE : DataManager = new DataManager();
		private var _database : PlowDatabaseConnection;
		private var _blueprints : Array;

		public static function getInstance() : DataManager {
			return INSTANCE;
		}

		public function DataManager() {
			if (INSTANCE) throw new Error("singleton: use DataManager.getInstance()");

			_database = new PlowDatabaseConnection();
			_database.addEventListener(Event.CHANGE, handleDatabaseUpdate);
		}

		private function handleDatabaseUpdate(event : Event) : void {
			_blueprints = _database.getBlueprints();
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function getDataProvider() : ArrayCollection {
			var ac : ArrayCollection = new ArrayCollection();
			for each (var blueprint : BlueprintData in _blueprints) {
				ac.addItem(blueprint.toObject());
			}
			return ac;
		}

		public function addFolderAsTemplate() : void {
			var directory : File = File.documentsDirectory;
			directory.browseForDirectory("Select Directory");
			directory.addEventListener(Event.SELECT, directorySelected);
		}

		private function directorySelected(event : Event) : void {
			var directory : File = event.target as File;
			var d : BlueprintData = new BlueprintData();
			d.parseFromFile(directory);
			_database.saveNewItem(d);
		}

		public function getItemByID(inID : int) : BlueprintData {
			for each (var blueprint : BlueprintData in _blueprints) {
				if (blueprint.id == inID)
					return blueprint;
			}
			return null;
		}
	}
}
