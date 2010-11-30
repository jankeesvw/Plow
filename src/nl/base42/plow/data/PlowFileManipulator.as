package nl.base42.plow.data {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import nl.base42.plow.data.dto.BlueprintData;
	import nl.base42.plow.data.dto.BlueprintReplaceData;
	import nl.base42.plow.utils.StringUtils;

	/**
	 * @author jankees [at] base42.nl
	 */
	public class PlowFileManipulator {
		private var _replaceFields : Array;
		private var _dm : DataManager;

		public function PlowFileManipulator(inSelectedItem : BlueprintData) {
			_replaceFields = inSelectedItem.getPlowReplaceFields();
			_dm = DataManager.getInstance();
		}

		public function start(targetFolder : File) : void {
			processFileContentRecursive(targetFolder);
			processFilenamesRecursive(targetFolder);
			processFoldernamesRecursive(targetFolder);
			removePlowFile(targetFolder);

			// open folder
			targetFolder.openWithDefaultApplication();
		}

		private function processFoldernamesRecursive(targetFolder : File) : void {
			var contents : Array = targetFolder.getDirectoryListing();
			for each (var file : File in contents) {
				if (file.isDirectory) {
					var newFolder : File = updateFolderName(file);
					processFoldernamesRecursive(newFolder);
				}
			}
		}

		private function updateFolderName(file : File) : File {
			var filename : String = file.name;

			for each ( var replacement : BlueprintReplaceData in _replaceFields) {
				filename = StringUtils.replace(filename, replacement.replace, replacement.text);
			}

			if (filename != file.name) {
				// move folder
				var folder : String = file.nativePath.substr(0, file.nativePath.length - file.name.length);
				var newfile : File = new File(folder + filename);
				file.moveTo(newfile);
				debug("updateFolderName: update folder name");
				return newfile;
			}
			return file;
		}

		private function removePlowFile(targetFolder : File) : void {
			var plowfile : File = new File(targetFolder.nativePath + File.separator + BlueprintData.PLOW_BLUEPRINT_FILE);
			if (plowfile.exists) {
				plowfile.deleteFile();
			}
		}

		private function processFilenamesRecursive(targetFolder : File) : void {
			var contents : Array = targetFolder.getDirectoryListing();
			for each (var file : File in contents) {
				if (file.isDirectory) {
					processFilenamesRecursive(file);
				} else {
					processFilename(file);
				}
			}
		}

		private function processFileContentRecursive(targetFolder : File) : void {
			var contents : Array = targetFolder.getDirectoryListing();

			for each (var file : File in contents) {
				if (file.isDirectory) {
					processFileContentRecursive(file);
				} else {
					processFileContents(file);
				}
			}
		}

		private function processFilename(file : File) : void {
			var filename : String = file.name;

			for each ( var replacement : BlueprintReplaceData in _replaceFields) {
				filename = StringUtils.replace(filename, replacement.replace, replacement.text);
			}

			if (filename != file.name) {
				// move file
				var folder : String = StringUtils.remove(file.nativePath, file.name);
				file.moveTo(new File(folder + filename));
			}
		}

		private function processFileContents(file : File) : void {
			if (_dm.isValidExtension(file.extension)) {
				var fileStream : FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				
				var b : ByteArray = new ByteArray();
				fileStream.readBytes(b, 0, fileStream.bytesAvailable);

				var content : String = b.readUTFBytes(b.length);
				for each ( var replacement : BlueprintReplaceData in _replaceFields) {
					content = StringUtils.replace(content, replacement.replace, replacement.text);
				}

				b = new ByteArray();
				b.writeUTFBytes(content);

				fileStream.close();

				fileStream = new FileStream();
				fileStream.open(file, FileMode.WRITE);
				fileStream.writeBytes(b, 0, b.bytesAvailable);
				fileStream.close();
			} else {
				status("processFileContents; don't process this extension: " + file.extension);
			}
		}
	}
}
