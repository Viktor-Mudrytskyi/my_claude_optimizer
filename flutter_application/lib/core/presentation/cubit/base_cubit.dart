import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_application/core/error/failure.dart';

abstract class BaseCubit<S> extends Cubit<S> {
  BaseCubit(super.initialState);

  Future<void> executeUseCase<T>({
    required Future<Either<Failure, T>> Function() useCase,
    required S Function() onLoading,
    required S Function(T data) onSuccess,
    required S Function(String message) onError,
  }) async {
    emit(onLoading());
    final result = await useCase();
    result.fold(
      (failure) => emit(onError(failure.message)),
      (data) => emit(onSuccess(data)),
    );
  }
}
