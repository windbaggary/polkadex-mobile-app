import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/usecases/confirm_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_main_account_address_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/import_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/register_user_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_password_usecase.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit({
    required GetAccountUseCase getAccountStorageUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required DeletePasswordUseCase deletePasswordUseCase,
    required ImportAccountUseCase importAccountUseCase,
    required SaveAccountUseCase saveAccountUseCase,
    required SavePasswordUseCase savePasswordUseCase,
    required GetPasswordUseCase getPasswordUseCase,
    required ConfirmPasswordUseCase confirmPasswordUseCase,
    required RegisterUserUseCase registerUserUseCase,
    required GetMainAccountAddressUsecase getMainAccountAddressUsecase,
  })  : _getAccountStorageUseCase = getAccountStorageUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _deletePasswordUseCase = deletePasswordUseCase,
        _importAccountUseCase = importAccountUseCase,
        _saveAccountUseCase = saveAccountUseCase,
        _savePasswordUseCase = savePasswordUseCase,
        _getPasswordUseCase = getPasswordUseCase,
        _confirmPasswordUseCase = confirmPasswordUseCase,
        _getMainAccountAddressUsecase = getMainAccountAddressUsecase,
        super(AccountInitial());

  final GetAccountUseCase _getAccountStorageUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final DeletePasswordUseCase _deletePasswordUseCase;
  final ImportAccountUseCase _importAccountUseCase;
  final SaveAccountUseCase _saveAccountUseCase;
  final SavePasswordUseCase _savePasswordUseCase;
  final GetPasswordUseCase _getPasswordUseCase;
  final ConfirmPasswordUseCase _confirmPasswordUseCase;
  final GetMainAccountAddressUsecase _getMainAccountAddressUsecase;

  String get accountName {
    final currentState = state;

    return currentState is AccountLoaded ? currentState.account.name : '';
  }

  String get mainAccountAddress {
    final currentState = state;

    return currentState is AccountLoaded
        ? currentState.account.mainAddress
        : '';
  }

  String get proxyAccountAddress {
    final currentState = state;

    return currentState is AccountLoaded
        ? currentState.account.proxyAddress
        : '';
  }

  bool get biometricAccess {
    final currentState = state;

    return currentState is AccountLoaded
        ? currentState.account.biometricAccess
        : false;
  }

  bool get biometricOnly {
    final currentState = state;

    return currentState is AccountLoaded
        ? currentState.account.biometricOnly
        : true;
  }

  EnumTimerIntervalTypes get timerInterval {
    final currentState = state;

    return currentState is AccountLoaded
        ? currentState.account.timerInterval
        : EnumTimerIntervalTypes.oneMinute;
  }

  Future<void> loadAccountData() async {
    final account = await _getAccountStorageUseCase();

    account != null
        ? emit(AccountLoaded(account: account))
        : emit(AccountNotLoaded());
  }

  Future<void> logout() async {
    emit(AccountNotLoaded());

    await _deleteAccountUseCase();
    await _deletePasswordUseCase();

    return;
  }

  Future<bool> savePassword(String password) async {
    return await _savePasswordUseCase(password: password);
  }

  Future<bool> authenticateBiometric() async {
    final currentState = state;

    if (currentState is AccountLoaded) {
      final password = await _getPasswordUseCase();

      return await confirmPassword(password!);
    }

    return false;
  }

  Future<void> saveAccount(List<String> mnemonicWords, String password,
      String name, bool biometricOnly, bool useBiometric) async {
    final resultImport = await _importAccountUseCase(
      mnemonic: mnemonicWords.join(' '),
      password: password,
    );

    await resultImport.fold(
      (_) {},
      (importedAcc) async {
        final resultMainAddress = await _getMainAccountAddressUsecase(
          proxyAdrress: importedAcc.proxyAddress,
        );

        resultMainAddress.fold(
          (_) {},
          (mainAddress) async {
            ImportedAccountEntity acc =
                (importedAcc as ImportedAccountModel).copyWith(
              name: name,
              mainAddress: mainAddress,
              biometricOnly: biometricOnly,
              biometricAccess: useBiometric,
            );

            emit(AccountLoaded(account: acc, password: password));
            await _saveAccountUseCase(keypairJson: json.encode(acc));
          },
        );
      },
    );
  }

  Future<bool> confirmPassword(String password) async {
    final currentState = state;

    if (currentState is AccountLoaded) {
      emit(AccountPasswordValidating(account: currentState.account));

      final confirmationResult = await _confirmPasswordUseCase(
        account: (currentState.account as ImportedAccountModel).toJson(),
        password: password,
      );

      emit(AccountLoaded(account: currentState.account, password: password));

      return confirmationResult;
    }

    return false;
  }

  Future<void> switchBiometricAccess() async {
    final currentState = state;

    if (currentState is AccountLoaded && currentState.password != null) {
      final currentBioAccess = currentState.account.biometricAccess;
      bool hasAuthNotFailed = true;

      emit(AccountUpdatingBiometric(
        account: currentState.account,
        password: currentState.password,
      ));

      if (!currentBioAccess) {
        hasAuthNotFailed =
            await _savePasswordUseCase(password: currentState.password!);
      }

      if (hasAuthNotFailed) {
        ImportedAccountEntity acc =
            (currentState.account as ImportedAccountModel)
                .copyWith(biometricAccess: !currentBioAccess);

        await _saveAccountUseCase(keypairJson: json.encode(acc));
        emit(AccountLoaded(
          account: acc,
          password: currentState.password,
        ));
      } else {
        emit(currentState);
      }
    }

    return;
  }

  Future<void> changeLockTimer(EnumTimerIntervalTypes newInterval) async {
    final currentState = state;

    if (currentState is AccountLoaded) {
      emit(AccountUpdatingTimer(
        account: currentState.account,
        password: currentState.password,
      ));

      ImportedAccountEntity acc = (currentState.account as ImportedAccountModel)
          .copyWith(timerInterval: newInterval);

      await _saveAccountUseCase(keypairJson: json.encode(acc));
      emit(AccountLoaded(
        account: acc,
        password: currentState.password,
      ));
    }
  }
}
