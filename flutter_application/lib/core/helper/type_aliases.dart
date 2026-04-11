import 'package:dartz/dartz.dart';
import 'package:flutter_application/core/error/failure.dart';

typedef FutureFailable<T> = Future<Either<Failure, T>>;
