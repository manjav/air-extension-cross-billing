package core {
	import flash.display.Bitmap;

	public class Assets {
		[Embed(source = "../../assets/buy_gas.png")]
		public static const buy_gas:Class;

		[Embed(source = "../../assets/drive.png")]
		public static const drive:Class;

		[Embed(source = "../../assets/free.png")]
		public static const free:Class;

		[Embed(source = "../../assets/gas_inf.png")]
		public static const gas_inf:Class;

		[Embed(source = "../../assets/gas0.png")]
		public static const gas0:Class;

		[Embed(source = "../../assets/gas1.png")]
		public static const gas1:Class;

		[Embed(source = "../../assets/gas2.png")]
		public static const gas2:Class;

		[Embed(source = "../../assets/gas3.png")]
		public static const gas3:Class;

		[Embed(source = "../../assets/gas4.png")]
		public static const gas4:Class;

		[Embed(source = "../../assets/get_infinite_gas.png")]
		public static const get_infinite_gas:Class;

		[Embed(source = "../../assets/ic_action_search.png")]
		public static const ic_action_search:Class;

		[Embed(source = "../../assets/ic_launcher.png")]
		public static const ic_launcher:Class;

		[Embed(source = "../../assets/manage_infinite_gas.png")]
		public static const manage_infinite_gas:Class;

		[Embed(source = "../../assets/premium.png")]
		public static const premium:Class;

		[Embed(source = "../../assets/title.png")]
		public static const title:Class;

		[Embed(source = "../../assets/upgrade_app.png")]
		public static const upgrade_app:Class;

		[Embed(source = "../../assets/wait.png")]
		public static const wait:Class;

		public static function getBitmap(name:String):Bitmap
		{
			return new Assets[name]() as Bitmap;
		}
	}
}
