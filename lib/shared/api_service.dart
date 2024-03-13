import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ebook_web/shared/cache_helper.dart';

class ApiService {
  static final Dio _dio = Dio();

  static Future<dynamic> api({
    String? endPoint,
    Map<String, dynamic>? data,
    String? fileKey,
    String? filePath,
    bool isRaw = false,
    required RequestType requestType,
  }) async {
    // try {
    String token = await CacheHelper.getSavedString('token', '');
    print("$endPoint called");
    print(token);
    print('jwt--------------');
    _dio.options.headers = {
      "Accept": "application/json",
      "Lang": "en",
      "api-token": "yama-vets",
      "Authorization": 'Bearer $token',
    };

    FormData formData = FormData();
    if (data != null) {
      data.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });
    }
    if (fileKey != null && filePath != '') {
      formData.files.add(
        MapEntry(
          fileKey,
          await MultipartFile.fromFile(filePath!),
        ),
      );
    }
    print("api : $endPoint");
    final response = requestType == RequestType.post
        ? await _dio.post(
      '$endPoint',
      data: isRaw ? data : formData,
    )
        : requestType == RequestType.get
        ? await _dio.get(
      '$endPoint',
      data: isRaw ? data : formData,
    )
        : requestType == RequestType.update
        ? await _dio.put(
      '$endPoint',
      data: isRaw ? data : formData,
    )
        : await _dio.delete(
      '$endPoint',
      data: isRaw ? data : formData,
    );

    print(response.statusCode);

    if (response.statusCode == 200) {

      return response;
    } else {
      print(response.statusCode);
    }
    // } catch (e) {
    //   print("Error occurred: $e");
    // }
  }
}

enum RequestType {
  post,
  get,
  update,
  delete,
}