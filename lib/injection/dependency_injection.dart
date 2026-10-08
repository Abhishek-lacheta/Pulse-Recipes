import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../core/network/rest_client.dart';
import '../data/datasources/remote/meal_remote_data_source.dart';
import '../data/repositories/meal_repository.dart';
import '../data/repositories/meal_repository_impl.dart';

/// Central dependency container managing production services and repositories.
class DependencyInjection {
  DependencyInjection._();

  static late final Dio dio;
  static late final RestClient restClient;
  static late final MealRemoteDataSource mealRemoteDataSource;
  static late final MealRepository mealRepository;

  static void init() {
    dio = DioClient.createDio();
    restClient = RestClient(dio);
    mealRemoteDataSource = MealRemoteDataSourceImpl(restClient);
    mealRepository = MealRepositoryImpl(mealRemoteDataSource);
  }
}
