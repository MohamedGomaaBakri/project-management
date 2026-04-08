import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shehabapp/core/api/api_constants.dart';
import 'package:shehabapp/core/models/band_and_items_model/band_and_items_model.dart';
import 'package:shehabapp/core/models/bands_model/bands_model.dart';
import 'package:shehabapp/core/models/items_model/items_model.dart';

class BandItemsService {
  Future<BandAndItemsModel> getAllBandItems() async {
    try {
      final url =
          '${ApiConstants.baseUrl}${ApiConstants.getAllBandItemsEndpoint}';
      log('🌐 API Request URL: $url', name: 'getAllBandItems');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log(
          '✅ API Response (getAllBandItems): $responseBody',
          name: 'getAllBandItems',
        );

        final BandAndItemsModel bandsAndItems = BandAndItemsModel.fromJson(
          json.decode(responseBody),
        );
        return bandsAndItems;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getAllBandItems',
        );
        throw Exception('Failed to load task proccess data.');
      }
    } catch (e) {
      log('💥 Exception in getAllBandItems: $e', name: 'getAllBandItems');
      throw Exception('An error occurred while fetching task proccess: $e');
    }
  }

  Future<BandsModel> getBands({required String projectId}) async {
    try {
      final url =
          '${ApiConstants.baseUrl}${ApiConstants.getBandsEndpoint}$projectId';
      log('🌐 API Request URL: $url', name: 'getBands');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log('✅ API Response (getBands): $responseBody', name: 'getBands');

        final BandsModel bands = BandsModel.fromJson(json.decode(responseBody));
        return bands;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getBands',
        );
        throw Exception('Failed to load task proccess data.');
      }
    } catch (e) {
      log('💥 Exception in getBands: $e', name: 'getBands');
      throw Exception('An error occurred while fetching task proccess: $e');
    }
  }

  Future<ItemsModel> getItems({required String projectId}) async {
    try {
      final url =
          '${ApiConstants.baseUrl}${ApiConstants.getItemsEndpoint}$projectId';
      log('🌐 API Request URL: $url', name: 'getItems');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        log('✅ API Response (getItems): $responseBody', name: 'getItems');

        final ItemsModel items = ItemsModel.fromJson(json.decode(responseBody));
        return items;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getItems',
        );
        throw Exception('Failed to load task proccess data.');
      }
    } catch (e) {
      log('💥 Exception in getItems: $e', name: 'getItems');
      throw Exception('An error occurred while fetching task proccess: $e');
    }
  }

  Future<void> createBandOrItem({required Map<String, dynamic> body}) async {
    try {
      final url =
          '${ApiConstants.baseUrl}${ApiConstants.getAllBandItemsEndpoint}';
      log('🌐 API Request URL: $url', name: 'createBandOrItem');
      log('📤 Request Body: ${json.encode(body)}', name: 'createBandOrItem');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        String responseBody = utf8.decode(response.bodyBytes);
        log(
          '✅ API Response (createBandOrItem): $responseBody',
          name: 'createBandOrItem',
        );
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'createBandOrItem',
        );
        throw Exception('Failed to create band or item. Status: ${response.statusCode}');
      }
    } catch (e) {
      log('💥 Exception in createBandOrItem: $e', name: 'createBandOrItem');
      throw Exception('An error occurred while creating band or item: $e');
    }
  }
}
