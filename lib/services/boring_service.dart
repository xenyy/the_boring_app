import 'package:the_boring_app/models/boringActivity_model.dart';
import 'package:the_boring_app/services/boring_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/all.dart';

final boringServiceProvider = Provider<BoringService>((ref)=> BoringService(Dio()));

abstract class BoringServices {
  Future<BoringActivity> getBoringActivity ();
}

class BoringService implements BoringServices{
  final Dio _dio;
  BoringService(this._dio);

  String _baseUrl = 'https://www.boredapi.com/api/activity/';

  @override
  Future<BoringActivity> getBoringActivity () async {
    try{
      final response = await _dio.get(_baseUrl);
      BoringActivity boringActivity = BoringActivity.fromJson(response.data);
      return boringActivity;
    } on DioError catch (dioError){
      throw BoringException.fromDioError(dioError);
    }
  }
}