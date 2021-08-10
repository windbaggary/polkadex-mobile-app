class ApiError {
  const ApiError({
    this.message,
  });

  final String? message;

  factory ApiError.fromJson(String message) {
    return ApiError(message: message);
  }
}
