// Core
import 'configuration_test.dart' as configuration_test;
import 'data_space_test.dart' as data_space_test;
import 'dictionary_test.dart' as dictionary_test;
import 'errors_test.dart' as errors_test;
import 'object_space_test.dart' as object_space_test;
import 'primitives_test.dart' as primitives_test;
import 'stack_test.dart' as stack_test;
import 'virtual_machine_test.dart' as virtual_machine_test;

main() {
	configuration_test.main();
	data_space_test.main();
	dictionary_test.main();
	errors_test.main();
	object_space_test.main();
	primitives_test.main();
	stack_test.main();
	virtual_machine_test.main();
}
