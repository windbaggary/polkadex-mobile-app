import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/orders/domain/entities/order_entity.dart';
import 'package:polkadex/common/orders/domain/repositories/iorder_repository.dart';

class PlaceOrderUseCase {
  PlaceOrderUseCase({
    required IOrderRepository orderRepository,
  }) : _orderRepository = orderRepository;

  final IOrderRepository _orderRepository;

  Future<Either<ApiError, OrderEntity>> call({
    required int nonce,
    required String baseAsset,
    required String quoteAsset,
    required EnumOrderTypes orderType,
    required EnumBuySell orderSide,
    required String price,
    required String amount,
    required String address,
    required String signature,
  }) async {
    return await _orderRepository.placeOrder(
      nonce,
      baseAsset,
      quoteAsset,
      orderType,
      orderSide,
      price,
      amount,
      address,
      signature,
    );
  }
}
