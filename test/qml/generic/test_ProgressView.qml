import QtTest 1.10

TestCase {
	name: "ModuleImportTest"
	id: parent

	function test_load_ProgressView() {
		var item = createTemporaryQmlObject("
			import Governikus.ProgressView 1.0;
			ProgressView {}
			", parent);
		item.destroy();
	}
}
