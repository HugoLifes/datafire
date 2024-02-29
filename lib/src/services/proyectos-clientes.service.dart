import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchCustomerProjects() async {
  const url = "http://localhost:3000/Api/v1/proyectos/projectCustomer";

  try {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<dynamic> customersProjects = jsonDecode(res.body);
      return customersProjects;
    } else {
      return [];
    }
  } catch (err) {
    return [];
  }
}

Future<List<String>> fetchCustomerProjectsforcustomers() async {
  const url = "http://localhost:3000/Api/v1/proyectos/projectCustomer";

  try {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<String> customersProjects = jsonDecode(res.body);
      return customersProjects;
    } else {
      return [];
    }
  } catch (err) {
    return [];
  }
}

class PostCustomerProject {
  Future<bool> addCustomerProject(String projectId, String customerId) async {
    final Map<String, dynamic> requestData = {
      "project_id": projectId,
      "customer_id": customerId,
    };
    const url = "http://localhost:3000/Api/v1/proyectos/projectCustomer";

    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (res.statusCode == 201) {
        return true; 
      } else {
        return false; 
      }
    } catch (err) {
      return false; 
    }
  }
}


Future<bool> deleteCustomerProjectRelation(int customerProjectId) async {
  final url =
      "https://datafire-production.up.railway.app/api/v1/proyectos/projectCustomer/$customerProjectId";

  try {
    final res = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );

    if (res.statusCode == 200) {
      return true; 
    } else {
      return false; 
    }
  } catch (err) {
    return false; 
  }
}


Future<List<Map<String, dynamic>>> fetchCustomerProjectsbyId(int customerId) async {
  const url = "https://datafire-production.up.railway.app/api/v1/proyectos/projectCustomer";

  try {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<Map<String, dynamic>> allProjects = List<Map<String, dynamic>>.from(jsonDecode(res.body));

      final List<Map<String, dynamic>> customerProjects = allProjects
          .where((project) => project['customer_id'] == customerId)
          .toList();

      return customerProjects;
    } else {
      return [];
    }
  } catch (err) {
    return [];
  }
}