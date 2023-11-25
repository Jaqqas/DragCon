import 'dart:convert';

import 'package:dragcon/config.dart';
import 'package:dragcon/web_api/dto/task_dto.dart';
import 'package:dragcon/web_api/dto/task_dto_post.dart';
import 'package:dragcon/web_api/exceptions/cant_fetch_data.dart';
import 'package:dragcon/web_api/service/api_service.dart';
import 'package:http/http.dart';

class TaskConnection {
  final apiService = ApiService();

  Future<TaskDto> getTaskById(int id) async {
    final Response response = await apiService.makeApiGetRequest('$apiHost/api/tasks/$id');

    if (response.statusCode == 404) {
      throw CantFetchDataException();
    } else {
      return TaskDto.fromJson(jsonDecode(response.body));
    }
  }

  patchTaskById(int id, TaskDto taskDto) async {
    final Response response = await apiService.patch('$apiHost/api/tasks/$id', taskDto);
    return response.statusCode;
  }

  addNewTask(TaskDtoPost taskDtoPost) async {
    print(taskDtoPost.toJson());
    final Response response = await apiService.post('$apiHost/api/tasks', taskDtoPost);
    print(response.body);
    return response.statusCode;
  }

  deleteTask(int id) async {
    final Response response = await apiService.delete('$apiHost/api/tasks/$id');
    return response.statusCode;
  }

  Future<List<TaskDto>> getAllTasksByEkipaId(int id) async {
    List<TaskDto> dtos = [];
    int pageNumber = 1;

    while (true) {
      print("witam");
      var items = await _getDtosByPageNumberAndId(pageNumber, id);
      if (items.isEmpty) {
        break;
      } else {
        pageNumber++;
      }

      dtos.addAll(items);
      return dtos;
    }
    return dtos;
  }

  Future<List<TaskDto>> _getDtosByPageNumberAndId(
    int pageNumber,
    int id,
  ) async {
    print("xd");
    var response = await apiService.makeApiGetRequest(
      '$apiHost/tasks-by-ekipa/$id?page=$pageNumber',
    );

    print(response.body);

    if (response.statusCode != 400) {
      var decodedBody = json.decode(response.body);
      var taskList = List<Map<String, dynamic>>.from(decodedBody);
      return taskList.map((e) => TaskDto.fromJson(e)).toList();
    } else {
      throw CantFetchDataException();
    }
  }

  Future<List<TaskDto>> getAllTasks() async {
    var response = await apiService.makeApiGetRequest(
      '$apiHost/api/tasks?page=1',
    );

    if (response.statusCode != 400) {
      var decodedBody = json.decode(response.body);
      var taskList = List<Map<String, dynamic>>.from(decodedBody);
      return taskList.map((e) => TaskDto.fromJson(e)).toList();
    } else {
      throw CantFetchDataException();
    }
  }
}
