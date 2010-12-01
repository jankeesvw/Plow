package nl.base42.plow.data {
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;

	import flash.display.Stage;

	/**
	 * @author jankees
	 */
	public class Analytics {
		private static const INSTANCE : Analytics = new Analytics();
		private var _tracker : AnalyticsTracker;
		private var _version : String;

		public static function getInstance() : Analytics {
			return INSTANCE;
		}

		public function start(inStage : Stage, inVersion : String) : void {
			_version = inVersion;
			_tracker = new GATracker(inStage, "UA-2530356-19", "AS3", false);
		}

		public function Analytics() {
			if (INSTANCE) throw new Error("singleton: use AnalyticsTracker.getInstance()");
		}

		public function track(inTrack : String) : void {
			if (_tracker) _tracker.trackPageview("/plow/" + _version + escape(inTrack));
		}
	}
}
