import 'package:fpdart/fpdart.dart';
import 'package:new_reddit_clone/core/Failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;

typedef FutureVoid<T> = FutureEither<void>;
