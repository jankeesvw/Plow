package nl.base42.plow.utils {
	import flash.utils.ByteArray;

	import nl.base42.plow.data.dvo.BlueprintData;
	import nl.base42.plow.data.dvo.BlueprintReplaceData;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	/**
	 * @author jankees [at] base42.nl
	 */
	public class PlowFileManipulator {
		private var _rules : Array;

		public function PlowFileManipulator(inSelectedItem : BlueprintData) {
			_rules = inSelectedItem.getPlowReplaceFields();
		}

		public function start(targetFolder : File) : void {
			processFileContentRecursive(targetFolder);
			processFilenamesRecursive(targetFolder);
			processFoldernamesRecursive(targetFolder);
			removePlowFile(targetFolder);

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

			for each ( var replacement : BlueprintReplaceData in _rules) {
				filename = StringUtils.replace(filename, replacement.replace, replacement.text);
			}

			if (filename != file.name) {
				// move folder
				var folder : String = file.nativePath.substr(0, file.nativePath.length - file.name.length);
				var newfile : File = new File(folder + filename);
				file.moveTo(newfile);

				status("update folder -> " + file.nativePath);

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

			for each ( var replacement : BlueprintReplaceData in _rules) {
				filename = StringUtils.replace(filename, replacement.replace, replacement.text);
			}

			if (filename != file.name) {
				// move file
				var folder : String = StringUtils.remove(file.nativePath, file.name);
				file.moveTo(new File(folder + filename));
			}
		}

		private function processFileContents(file : File) : void {
			var fileStream : FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);

			var b : ByteArray = new ByteArray();
			fileStream.readBytes(b, 0, fileStream.bytesAvailable);
			
			var content:String = b.readUTFBytes(b.bytesAvailable);
			for each ( var replacement : BlueprintReplaceData in _rules) {
				content = StringUtils.replace(content, replacement.replace, replacement.text);
			}
			
			b = new ByteArray();
			b.writeUTFBytes(content);
			
			fileStream.close();
			
			fileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(b,0,b.bytesAvailable);
			fileStream.close();
		}
	}
}
