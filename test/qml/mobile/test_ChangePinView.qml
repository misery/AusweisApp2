import QtTest 1.10

TestCase {
	name: "ModuleImportTest"
	id: parent

	function test_load_ChangePinView() {
		var item = createTemporaryQmlObject("
			import Governikus.ChangePinView 1.0;
			ChangePinView {}
			", parent);
		item.destroy();
	}
}
