package nl.base42.plow.data {
	import nl.base42.plow.data.dvo.BlueprintData;

	import mx.collections.ArrayCollection;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	/**
	 * @author jankees [at] base42.nl
	 */
	public class DataManager extends EventDispatcher {
		private static const INSTANCE : DataManager = new DataManager();
		private var _database : PlowDatabaseConnection;
		private var _blueprints : Array;
		private var _extensions : Array;

		public static function getInstance() : DataManager {
			return INSTANCE;
		}

		public function DataManager() {
			if (INSTANCE) throw new Error("singleton: use DataManager.getInstance()");

			_database = new PlowDatabaseConnection();
			_database.addEventListener(Event.CHANGE, handleDatabaseUpdate);

			loadExtensions();
		}

		private function loadExtensions() : void {
			var fileStream : FileStream = new FileStream();
			var file : File = new File(File.applicationDirectory.nativePath + File.separator + "extensions.xml");
			fileStream.open(file, FileMode.READ);
			var xml : XML = XML(fileStream.readMultiByte(file.size, File.systemCharset));
			debug("loadExtensions: xml: " + (xml));
			fileStream.close();
			_extensions = [];
			for each (var ext : String in xml.child("extensions").child("extension")) {
				_extensions.push(ext);
			}
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

		public function isValidExtension(inExtension : String) : Boolean {
			if (!inExtension) return false;
			
			for each (var extension : String in _extensions) {
				if (extension.toUpperCase() == inExtension.toUpperCase()) return true;
			}
			return false;
		}

		public function removeItemByID(id : int) : void {
			var d : BlueprintData = getItemByID(id);
			_database.deleteItem(d);
		}
	}
}
