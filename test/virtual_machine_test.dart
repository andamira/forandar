library forandar.core.virtual_machine_test;

import "package:test/test.dart";

import "package:forandar/forandar.dart";

void main() {

	VirtualMachine vm;

	/// Tests the [VirtualMachine] class.
	group("[VirtualMachine]", () {

		test("Constructor", () {
			vm = new VirtualMachine(config: new Configuration());
			expect(vm, isNotNull);
		});

		test("Constructor (singleton test)", () {
			expect(vm.hashCode, equals(new VirtualMachine().hashCode));
		});

		group("State:", () {

			test("compilationState (default false)", () {
				expect(vm.compilationState, equals(false));
			});

			test("interpretationState (default true)", () {
				expect(vm.interpretationState, equals(true));
			});

			test("compilationState (set true, get true)", () {
				vm.compilationState = true;
				expect(vm.compilationState, equals(true));
			});

			test("interpretationState (get false)", () {
				expect(vm.interpretationState, equals(false));
			});

			test("interpretationState (set true, get true)", () {
				vm.interpretationState = true;
				expect(vm.interpretationState, equals(true));
			});

			test("compilationState (get false)", () {
				expect(vm.compilationState, equals(false));
			});

		});
	});
}
