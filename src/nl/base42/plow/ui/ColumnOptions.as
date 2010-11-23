package nl.base42.plow.ui {
	import spark.components.Button;

	import mx.controls.dataGridClasses.MXDataGridItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;

	/**
	 * @author jankees [at] base42.nl
	 */
	public class ColumnOptions extends MXDataGridItemRenderer implements IListItemRenderer {
		public static const DELETE_BUTTON_ID : String = "DELETE_BUTTON";

		public function ColumnOptions() {
			var deleteButton : Button = new Button();
			deleteButton.id = DELETE_BUTTON_ID;
			deleteButton.label = "delete";
			deleteButton.x = 5;
			addElement(deleteButton);
		}
	}
}
