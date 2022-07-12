import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polkadex/common/orderbook/data/models/orderbook_model.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_entity.dart';
import 'package:polkadex/common/orderbook/domain/usecases/fetch_orderbook_data_usecase.dart';
import 'package:polkadex/common/orderbook/domain/usecases/fetch_orderbook_live_data_usecase.dart';

part 'orderbook_state.dart';

class OrderbookCubit extends Cubit<OrderbookState> {
  OrderbookCubit({
    required FetchOrderbookDataUseCase fetchOrderbookDataUseCase,
    required FetchOrderbookUpdatesUseCase fetchOrderbookUpdatesUseCase,
  })  : _fetchOrderbookDataUseCase = fetchOrderbookDataUseCase,
        _fetchOrderbookUpdatesUseCase = fetchOrderbookUpdatesUseCase,
        super(OrderbookInitial());

  final FetchOrderbookDataUseCase _fetchOrderbookDataUseCase;
  final FetchOrderbookUpdatesUseCase _fetchOrderbookUpdatesUseCase;

  Future<void> fetchOrderbookData({
    required String leftTokenId,
    required String rightTokenId,
  }) async {
    emit(OrderbookLoading());

    final resultData = await _fetchOrderbookDataUseCase(
      leftTokenId: leftTokenId,
      rightTokenId: rightTokenId,
    );

    await _fetchOrderbookUpdatesUseCase(
      leftTokenId: leftTokenId,
      rightTokenId: rightTokenId,
      onMsgReceived: (putsList, delsList) {
        final currentState = state;

        if (currentState is OrderbookLoaded) {
          final currentOrderbook = currentState.orderbook as OrderbookModel;
          emit(
            OrderbookLoaded(
              orderbook: currentOrderbook.update(putsList, delsList),
            ),
          );
        }
      },
      onMsgError: (_) {},
    );

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
