import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_entity.dart';
import 'package:polkadex/common/orderbook/domain/usecases/fetch_orderbook_data_usecase.dart';
import 'package:polkadex/common/orderbook/domain/usecases/fetch_orderbook_live_data_usecase.dart';

part 'orderbook_state.dart';

class OrderbookCubit extends Cubit<OrderbookState> {
  OrderbookCubit({
    required FetchOrderbookDataUseCase fetchOrderbookDataUseCase,
    required FetchOrderbookLiveDataUseCase fetchOrderbookLiveDataUseCase,
  })  : _fetchOrderbookDataUseCase = fetchOrderbookDataUseCase,
        super(OrderbookInitial());

  final FetchOrderbookDataUseCase _fetchOrderbookDataUseCase;

  Future<void> fetchOrderbookData({
    required String leftTokenId,
    required String rightTokenId,
  }) async {
    emit(OrderbookLoading());

    final resultData = await _fetchOrderbookDataUseCase(
      leftTokenId: leftTokenId,
      rightTokenId: rightTokenId,
    );

    //final resultLiveData = await _fetchOrderbookLiveDataUseCase(
    //  leftTokenId: leftTokenId,
    //  rightTokenId: rightTokenId,
    //  onMsgReceived: (orderbookMsg) {
    //    emit(OrderbookLoaded(orderbook: orderbookMsg));
    //  },
    //  onMsgError: (error) => emit(
    //    OrderbookError(
    //      errorMessage: error.toString(),
    //    ),
    //  ),
    //);

    //resultLiveData.fold(
    //    (error) => emit(
    //          OrderbookError(errorMessage: error.message),
    //        ),
    //    (_) => null);

    final currentState = state;

    if (currentState is OrderbookLoading) {
      resultData.fold(
        (error) => emit(
          OrderbookError(errorMessage: error.message),
        ),
        (orderbook) => emit(
          OrderbookLoaded(orderbook: orderbook),
        ),
      );
    }
  }
}
