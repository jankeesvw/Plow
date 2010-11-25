package nl.base42.plow.ui {
	import nl.base42.plow.data.PlowFileManipulator;
	import nl.base42.plow.data.dvo.BlueprintData;
	import nl.base42.plow.data.dvo.BlueprintReplaceData;
	import nl.base42.plow.utils.PositionDebugBehavior;

	import spark.components.Button;
	import spark.components.Group;

	import mx.controls.Alert;
	import mx.controls.Text;
	import mx.core.mx_internal;
	import mx.managers.PopUpManager;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	/**
	 * @author jankees [at] base42.nl
	 */
	public class BlueprintForm extends Group {
		private var _blueprintData : BlueprintData;
		private var _alert : Alert;
		private var _targetFolder : File;
		private var _rules : Array;
		private var _blueprintFileManipulator : PlowFileManipulator;

		public function selectItem(inSelectedItem : BlueprintData) : void {
			_blueprintData = inSelectedItem;
			_blueprintFileManipulator = new PlowFileManipulator(inSelectedItem);

			buildForm();
		}

		private function buildForm() : void {
			removeAllElements();

			var generateButton : Button = new Button();
			generateButton.addEventListener(MouseEvent.CLICK, handleGenerateClick);
			generateButton.label = "Generate";
			generateButton.width = 132;
			generateButton.height = 30;
			generateButton.x = 115;
			generateButton.y = 378;
			addElement(generateButton);

			_rules = _blueprintData.getPlowReplaceFields();
			var leni : uint = _rules.length;
			for (var i : uint = 0; i < leni; i++) {
				var replacement : BlueprintReplaceData = _rules[i];
				var replacementGroup : ReplaceGroup = new ReplaceGroup(replacement);
				replacementGroup.y = i * 25;
				addElement(replacementGroup);
			}

			if (!_blueprintData.hasPlowConfigFile()) {
				var createSampleLabel : Text = new Text();
				createSampleLabel.x = 0;
				createSampleLabel.y = 5;
				createSampleLabel.width = 300;
				createSampleLabel.text = "This folder has no plow.xml this can be used to filenames, foldernames and the content of files. If you want to create a sample xml file click the button below. You have to modify this file to your needs.";
				addElement(createSampleLabel);

				var createSampleXML : Button = new Button();
				createSampleXML.addEventListener(MouseEvent.CLICK, handleSampleFileClick);
				createSampleXML.label = "Create sample XML in blueprint folder";
				createSampleXML.width = 232;
				createSampleXML.height = 30;
				createSampleXML.x = 34;
				createSampleXML.y = 82;
				addElement(createSampleXML);
			}
		}

		public function clear() : void {
			removeAllElements();
		}

		private function handleSampleFileClick(event : MouseEvent) : void {
			var samplePlowFile : File = File.applicationDirectory.resolvePath(BlueprintData.PLOW_BLUEPRINT_FILE);

			var destinationFolder : File = new File(_blueprintData.path + File.separator + BlueprintData.PLOW_BLUEPRINT_FILE);
			samplePlowFile.copyTo(destinationFolder);

			destinationFolder.openWithDefaultApplication();

			Alert.show("Plow created an example plow file in your folder: " + _blueprintData.path + ".  You have to modify this file to your needs!");

			dispatchEvent(new Event(Event.CHANGE));
		}

		private function handleGenerateClick(event : MouseEvent) : void {
			var directory : File = File.desktopDirectory;
			directory.browseForSave("Select target directory");
			directory.addEventListener(Event.SELECT, directorySelected);
		}

		private function directorySelected(event : Event) : void {
			var directory : File = event.target as File;
			_targetFolder = new File(directory.nativePath);

			var originalFolder : File = new File(_blueprintData.path);
			originalFolder.addEventListener(Event.COMPLETE, copyComplete);
			originalFolder.copyToAsync(_targetFolder);

			_alert = Alert.show("Copying files to " + _targetFolder.nativePath, "Working", Alert.NO, null, null);
			_alert.mx_internal::alertForm.removeChild(_alert.mx_internal::alertForm.mx_internal::buttons[0]);

			debug("copying to : " + _targetFolder.nativePath);
		}

		private function copyComplete(event : Event) : void {
			PopUpManager.removePopUp(_alert);

			// process file content
			_blueprintFileManipulator.start(_targetFolder);
		}
	}
}
