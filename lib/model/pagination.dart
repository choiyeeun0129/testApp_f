class Pagination<T> {
  final int page;
  final int totalCount;
  final List<T> list;

  Pagination({
    required this.page,
    required this.totalCount,
    required this.list,
  });

  factory Pagination.fromJson(dynamic response, List<T> list){
    return Pagination(
      page: int.parse(response["pagination"]["page"]),
      totalCount: response["pagination"]["totalCount"] as int,
      list: list,
    );
  }
}
