import 'package:benchmark_harness/benchmark_harness.dart';

class ForandarBenchmark extends BenchmarkBase {
	const ForandarBenchmark() : super("Forandar");

	static void main() {
		new ForandarBenchmark().report();
	}

	// The benchmark code.
	void run() {

	}

	// Not measured: setup code executed before the benchmark runs.
	void setup() { }

	// Not measured: teardown code executed after the benchmark runs.
	void teardown() { }
}

main() {

	ForandarBenchmark.main();
}



// other examples
// https://github.com/angular/di.dart/tree/master/benchmark
// https://github.com/angular/di.dart/tree/master/benchmark
// https://github.com/rwl/colt/blob/master/example/benchmark.dart
