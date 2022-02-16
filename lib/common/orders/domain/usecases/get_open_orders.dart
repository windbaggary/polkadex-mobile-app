import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/orders/domain/entities/order_entity.dart';
import 'package:polkadex/common/orders/domain/repositories/iorder_repository.dart';

class GetOpenOrdersUseCase {
  GetOpenOrdersUseCase({
    required IOrderRepository orderRepository,
  }) : _orderRepository = orderRepository;

  final IOrderRepository _orderRepository;

  Future<Either<ApiError, List<OrderEntity>>> call(
      {required String address, required String signature}) async {
    return await _orderRepository.fetchOpenOrders(address, signature);
  }
}
