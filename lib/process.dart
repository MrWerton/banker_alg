import './resource.dart';

class Process {
  String name;
  List<Resource> allocatedResources;
  List<Resource> needResources;

  Process(
      {required this.name,
      required this.allocatedResources,
      required this.needResources});
}
