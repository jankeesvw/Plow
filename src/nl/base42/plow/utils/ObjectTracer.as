/** *    *  This file is part of AS3FlashProject. * *  AS3FlashProject is free software: you can redistribute it and/or modify *  it under the terms of the GNU General Public License as published by *  the Free Software Foundation, either version 3 of the License. * *  AS3FlashProject is distributed in the hope that it will be useful, *  but WITHOUT ANY WARRANTY; without even the implied warranty of *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the *  GNU General Public License for more details. * *  You should have received a copy of the GNU General Public License *  along with AS3FlashProject.  If not, see <http://www.gnu.org/licenses/>. *   *  For more information contact one of the authors at www.inlet42.nl; *   */
package nl.base42.plow.utils {
	import flash.utils.describeType;

	public class ObjectTracer {
		public static function trace(inObject : Object) : String {			var result : String = "\n";			var objectXML : XML = describeType(inObject);
			var variablesList : XMLList = objectXML.child("variable");
			for (var i : int = 0 ;i < variablesList.length(); i++) {
				result += "[" + variablesList[i].@name + "] = " + inObject[variablesList[i].@name] + "\n";
			}
			for (var prop:String in inObject) {
				result += "[" + prop + "] = " + inObject[prop] + "\n";
			}
			return result;
		}
	}
}