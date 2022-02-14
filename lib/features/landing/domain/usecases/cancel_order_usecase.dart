import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/domain/repositories/iorder_repository.dart';

class CancelOrderUseCase {
  CancelOrderUseCase({
    required IOrderRepository orderRepository,
  }) : _orderRepository = orderRepository;

  final IOrderRepository _orderRepository;

  Future<Either<ApiError, String>> call(
      {required int nonce,
      required String address,
      required String orderId,
      required String signature}) async {
    return await _orderRepository.cancelOrder(
      nonce,
      address,
      orderId,
      signature,
    );
  }
}
