abstract class ApiInterface {
  Future<Map?> getData(String url);
  Future<Map?> sendData(List body, String url);
}