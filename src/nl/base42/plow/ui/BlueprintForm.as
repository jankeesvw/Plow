package nl.base42.plow.ui {
	import nl.base42.plow.data.dvo.BlueprintData;
	import nl.base42.plow.data.dvo.BlueprintReplaceData;
	import nl.base42.plow.utils.PlowFileManipulator;

	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.TextInput;

	import mx.controls.Alert;
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
		private var _outputNameField : TextInput;
		private var _alert : Alert;
		private var _targetFolder : File;
		private var _rules : Array;
		private var _blueprintFileManipulator : PlowFileManipulator;

		public function selectItem(inSelectedItem : BlueprintData) : void {
			_blueprintData = inSelectedItem;
			_blueprintFileManipulator = new PlowFileManipulator(inSelectedItem);
			removeAllElements();

			var generateButton : Button = new Button();
			generateButton.addEventListener(MouseEvent.CLICK, handleGenerateClick);
			generateButton.label = "Generate";
			generateButton.width = 132;
			generateButton.height = 30;
			generateButton.x = 115;
			generateButton.y = 378;
			addElement(generateButton);

			_outputNameField = new TextInput();
			_outputNameField.x = 150;
			addElement(_outputNameField);

			var label : Label = new Label();
			label.y = 6;
			label.text = "Output folder name";
			addElement(label);

			_rules = _blueprintData.getPlowReplaceFields();
			var leni : uint = _rules.length;
			for (var i : uint = 0; i < leni; i++) {
				var replacement : BlueprintReplaceData = _rules[i];
				var replacementGroup : ReplaceGroup = new ReplaceGroup(replacement);
				replacementGroup.y = i * 25 + 50;
				addElement(replacementGroup);
			}
		}

		private function handleGenerateClick(event : MouseEvent) : void {
			if (_outputNameField.text == "") {
				Alert.show("Please give a folder output name", "Oops");
				return;
			}
			var directory : File = File.desktopDirectory;
			directory.browseForDirectory("Select target directory");
			directory.addEventListener(Event.SELECT, directorySelected);
		}

		private function directorySelected(event : Event) : void {
			var directory : File = event.target as File;
			_targetFolder = new File(directory.nativePath + File.separator + _outputNameField.text);

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
