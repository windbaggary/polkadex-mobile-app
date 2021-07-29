class ApiError {
  const ApiError({
    this.message,
  });

  final String? message;

  factory ApiError.fromJson(Map<String, dynamic> map) {
    return ApiError(message: map['error']['message']);
  }
}
