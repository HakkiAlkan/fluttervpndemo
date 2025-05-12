class BaseError {
  BaseError({this.statusCode, this.message});

  int? statusCode;
  String? message;
}

class ResponseModel<T> {
  T? data;
  BaseError? error;

  ResponseModel({this.data, this.error});
}
