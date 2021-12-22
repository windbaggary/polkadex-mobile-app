import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/domain/entities/order_entity.dart';
import 'package:polkadex/features/landing/domain/repositories/iorder_repository.dart';

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
    required double price,
    required double quantity,
    required String signature,
  }) async {
    return await _orderRepository.placeOrder(
      nonce,
      baseAsset,
      quoteAsset,
      orderType,
      orderSide,
      price,
      quantity,
      signature,
    );
  }
}
