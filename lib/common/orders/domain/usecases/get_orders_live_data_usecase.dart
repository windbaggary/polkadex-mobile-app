import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/orders/domain/entities/order_update_entity.dart';
import 'package:polkadex/common/orders/domain/repositories/iorder_repository.dart';

class GetOrdersLiveDataUseCase {
  GetOrdersLiveDataUseCase({
    required IOrderRepository orderRepository,
  }) : _orderRepository = orderRepository;

  final IOrderRepository _orderRepository;

  Future<Either<ApiError, void>> call({
    required String address,
    required Function(OrderUpdateEntity) onMsgReceived,
    required Function(Object) onMsgError,
  }) async {
    return await _orderRepository.fetcOrdersLiveData(
      address,
      onMsgReceived,
      onMsgError,
    );
  }
}
