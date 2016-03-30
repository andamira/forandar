part of forandar.core.stack;

abstract class StackBase<T extends num> {

  final List<T> _data;
  final int _maxSize;
  int _size = 0;
  final StackType _type;

  StackBase(this._maxSize, this._data, this._type);

  /// Returns the type of the stack.
  StackType get type => _type;

  /// Returns the size of the stack.
  int get size => _size;

  /// Returns the maximum size of the stack.
  int get maxSize => _maxSize;

  /// Clears the contents of the stack.
  void clear() { _size = 0; }

  /// Returns the representation of the stack.
  List<T> content() => _data.sublist(0, _size);

  /// Replaces the content of the [Stack] with the elements of the list.
  void replace(List<T> l) {
    _size = 0;
    l.forEach( (v){
      _data[_size++] = v;
    });
  }

  @override
  String toString() => "<${_size}> ${content()}";
}

abstract class LifoStackInterface<T extends num> {
  drop();
  drop2();
  dup();
  dup2();
  nip();
  over();
  over2();
  T get peek;
  T get peekNOS;
  pick(int i);
  T get pop;
  List<T> popList(int i);
  push(T i);
  pushList(List<T> L);
  roll(int i);
  rot();
  rotCC();
  swap();
  swap2();
  tuck();
}

/// A concrete implementation of [LifoStack] for integers.
class LifoStackInt extends LifoStack<int> {
  LifoStackInt(maxSize, [StackType type = StackType.unknown]) :
    super(maxSize, new Int32List(maxSize), type);
}

/// A concrete implementation of [LifoStack] for floating point numbers.
class LifoStackFloat extends LifoStack<double> {
  LifoStackFloat(maxSize, [StackType type = StackType.unknown]) :
    super(maxSize, new Float64List(maxSize), type);
}
