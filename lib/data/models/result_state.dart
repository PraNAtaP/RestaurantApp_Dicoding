sealed class ResultState<T> {}

class Initial<T> extends ResultState<T> {}

class Loading<T> extends ResultState<T> {}

class HasData<T> extends ResultState<T> {
  final T data;
  HasData(this.data);
}

class NoData<T> extends ResultState<T> {
  final String message;
  NoData(this.message);
}

class ErrorState<T> extends ResultState<T> {
  final String message;
  ErrorState(this.message);
}
