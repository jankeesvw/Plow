package nl.base42.plow.utils {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.System;
	import flash.ui.Keyboard;

	/**
	 * @author Jankees van Woezik | Base42.nl
	 * 
	 * Usage:
	 * new PositionDebugBehavior(_arrow);
	 *
	 */
	public class PositionDebugBehavior {
		private var _displayObject : DisplayObject;
		private var _prefix : String;

		public function PositionDebugBehavior(inDisplayObject : DisplayObject, inPrefix : String = "") {
			_prefix = inPrefix;
			_displayObject = inDisplayObject;
			if (_displayObject.stage) {
				initialize();
			} else {
				_displayObject.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			}
		}

		private function handleAddedToStage(event : Event) : void {
			_displayObject.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			initialize();
		}

		private function initialize() : void {
			error("POSITION BEHAVIOUR INITIALIZED, REMOVE WHEN READY");
			_displayObject.stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyEvent);
		}

		private function handleKeyEvent(event : KeyboardEvent) : void {
			var x : int = 0;
			var y : int = 0;

			switch (event.keyCode) {
				case Keyboard.LEFT:
					x = -1;
					break;
				case Keyboard.RIGHT:
					x = 1;
					break;
				case Keyboard.UP:
					y = -1;
					break;
				case Keyboard.DOWN:
					y = 1;
					break;
			}

			if (event.shiftKey) {
				x *= 5;
				y *= 5;
			}

			if (event.ctrlKey) {
				x *= 10;
				y *= 10;
			}

			_displayObject.x += x;
			_displayObject.y += y;

			var prefix : String = _prefix != "" ? _prefix + "." : "";
			debug(prefix + "x = " + _displayObject.x + " " + prefix + "y = " + _displayObject.y + ";");

			try {
				System.setClipboard(prefix + "x = " + _displayObject.x + "; \n" + prefix + "y = " + _displayObject.y + ";");
			} catch (ei : Error) {
			}
		}
	}
}