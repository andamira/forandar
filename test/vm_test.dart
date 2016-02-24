library forandar.core.vm_test;

import "package:test/test.dart";

import "package:forandar/forandar.dart";

void main() {

	VirtualMachine vm;

	/// Tests the [VirtualMachine] class.
	group("VirtualMachine", () {

		test("Constructor", () {
			vm = new VirtualMachine(new Configuration(), new InputQueue());
			expect(vm, isNotNull);
		});

		test("Constructor (singleton test)", () {
			expect(vm.hashCode, equals(
				new VirtualMachine(new Configuration(), new InputQueue()).hashCode));
		});

		group("States:", () {

			test("compilationState (default false)", () {
				expect(vm.compilationState, equals(false));
			});

			test("interpretationState (default true)", () {
				expect(vm.interpretationState, equals(true));
			});

			test("compilationState (set true)", () {
				vm.compilationState = true;
				expect(vm.compilationState, equals(true));
			});

			test("interpretationState (set false)", () {
				vm.interpretationState = false;
				expect(vm.interpretationState, equals(false));
			});

		});
	});
}
