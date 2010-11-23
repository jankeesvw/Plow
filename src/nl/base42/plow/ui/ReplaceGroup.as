package nl.base42.plow.ui {
	import spark.events.TextOperationEvent;

	import nl.base42.plow.data.dvo.BlueprintReplaceData;

	import spark.components.Group;
	import spark.components.Label;
	import spark.components.TextInput;

	/**
	 * @author jankees [at] base42.nl
	 */
	public class ReplaceGroup extends Group {
		private var _data : BlueprintReplaceData;
		private var _inputfield : TextInput;

		public function ReplaceGroup(inBlueprintReplaceData : BlueprintReplaceData) {
			_data = inBlueprintReplaceData;

			_inputfield = new TextInput();
			_inputfield.x = 150;
			_inputfield.text = inBlueprintReplaceData.text;
			addElement(_inputfield);

			_inputfield.addEventListener(TextOperationEvent.CHANGE, handleChange);

			var label : Label = new Label();
			label.y = 6;
			label.text = inBlueprintReplaceData.label;
			addElement(label);
		}

		private function handleChange(event : TextOperationEvent) : void {
			_data.text = _inputfield.text;
		}
	}
}
