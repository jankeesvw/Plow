package nl.base42.plow.ui {
	import flash.display.BlendMode;
	import fla.robot.RobotGraphic;

	import mx.core.UIComponent;

	/**
	 * @author jankees
	 */
	public class Robot extends UIComponent {
		private var _robot : RobotGraphic;

		public function Robot() {
			_robot = new RobotGraphic();
			_robot.blendMode = BlendMode.LAYER;
			_robot.alpha = 0.8;
			_robot.x = 572;
			_robot.y = 274;
			addChild(_robot);
		}
	}
}
