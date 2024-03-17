import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class ApiService {
  static final Dio _dio = Dio();

  static Future<dynamic> api({
    String? endPoint,
    Map<String, dynamic>? data,
    String? fileKey,
    String? filePath,
    bool isRaw = false,
    String? baseUrl,
    Options? options,
    Function(int, int)? onReceiveProgress,
    required RequestType requestType,
    required BuildContext context,
  }) async {
    try {
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

      final response = requestType == RequestType.post
          ? await _dio.post(
        '$baseUrl$endPoint',
        data: isRaw ? data : formData,
      )
          : requestType == RequestType.get
          ? await _dio.get(
        '$baseUrl$endPoint',
        data: isRaw ? data : formData,
        options: options,
        onReceiveProgress: onReceiveProgress,
      )
          : requestType == RequestType.update
          ? await _dio.put(
        '$baseUrl$endPoint',
        data: isRaw ? data : formData,
      )
          : await _dio.delete(
        '$baseUrl$endPoint',
        data: isRaw ? data : formData,
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        return response;
      } else {
        print(response.statusCode);
      }
    } catch (error) {
      print("Error occurred: $error");
    }
  }
}

enum RequestType {
  post,
  get,
  update,
  delete,
}
