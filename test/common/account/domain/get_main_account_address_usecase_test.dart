import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/domain/repositories/iadress_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/get_main_account_address_usecase.dart';

class _AddressRepositoryMock extends Mock implements IAdressRepository {}

void main() {
  late GetMainAccountAddressUsecase _usecase;
  late _AddressRepositoryMock _repository;
  late String tProxyAddress;
  late String tMainAddress;

  setUp(() {
    _repository = _AddressRepositoryMock();
    _usecase = GetMainAccountAddressUsecase(addressRepository: _repository);
    tProxyAddress = "k9o1dxJxQE8Zwm5Fy";
    tMainAddress = "abcdefg123456789";
  });

  group('GetMainAccountAddressUsecase tests', () {
    test(
      'must have success on getting account main address',
      () async {
        // arrange
        when(() => _repository.fetchMainAddress(any())).thenAnswer(
          (_) async => Right(tMainAddress),
        );
        // act
        final result = await _usecase(proxyAdrress: tProxyAddress);
        // assert

        late String mainAddress;

        result.fold(
          (_) => null,
          (resultMnemonic) => mainAddress = resultMnemonic,
        );

        expect(mainAddress, tMainAddress);
        verify(() => _repository.fetchMainAddress(tProxyAddress)).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail on getting account main address',
      () async {
        // arrange
        when(() => _repository.fetchMainAddress(any())).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase(proxyAdrress: tProxyAddress);
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.fetchMainAddress(tProxyAddress)).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
