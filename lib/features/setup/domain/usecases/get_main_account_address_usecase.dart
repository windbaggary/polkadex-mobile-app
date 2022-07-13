import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/domain/repositories/iadress_repository.dart';

class GetMainAccountAddressUsecase {
  GetMainAccountAddressUsecase({
    required IAdressRepository addressRepository,
  }) : _addressRepository = addressRepository;

  final IAdressRepository _addressRepository;

  Future<Either<ApiError, String>> call({required String proxyAdrress}) async {
    return await _addressRepository.fetchMainAddress(proxyAdrress);
  }
}
