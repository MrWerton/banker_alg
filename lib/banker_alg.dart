import './resource.dart';
import './process.dart';

class BankersAlgorithm {
  List<Resource> availableResources;
  List<Process> processes;
  final List<String> history = [];

  BankersAlgorithm(this.availableResources, this.processes);

  void checkIfIsSafeState() {
    if (_isSafeState()) {
      print("Safe state.");
      _getHistory();
    } else {
      print("Unsafe state.");
    }
  }

  bool _isSafeState() {
    Set<int> executedProcesses = Set();
    List<Resource> availableResourcesCopy = List.from(availableResources);

    List<String> safeSequence = [];
    int completedProcesses = 0;

    while (completedProcesses < processes.length) {
      int processIndex =
          _findNextExecutableProcess(executedProcesses, availableResourcesCopy);
      if (processIndex == -1) {
        return false;
      }

      _executeProcess(processIndex, availableResourcesCopy, executedProcesses,
          safeSequence);
      completedProcesses++;
    }

    print("Safe sequence: ${safeSequence.join(', ')}");
    return true;
  }

  int _findNextExecutableProcess(
      Set<int> executedProcesses, List<Resource> availableResourcesCopy) {
    return processes.indexWhere((process) =>
        !_isProcessExecuted(process, executedProcesses) &&
        _isResourceAvailable(process, availableResourcesCopy));
  }

  bool _isProcessExecuted(Process process, Set<int> executedProcesses) {
    int processIndex = processes.indexOf(process);
    return executedProcesses.contains(processIndex);
  }

  bool _isResourceAvailable(
      Process process, List<Resource> availableResourcesCopy) {
    return process.needResources.every((needResource) =>
        needResource.quantity <=
        availableResourcesCopy
            .firstWhere((resource) => resource.name == needResource.name)
            .quantity);
  }

  void _executeProcess(int processIndex, List<Resource> availableResourcesCopy,
      Set<int> executedProcesses, List<String> safeSequence) {
    history.add('-------------------------------');
    Process process = processes[processIndex];
    history.add(process.name);
    history.add(
        "before ${availableResourcesCopy.map((e) => '${e.name}=${e.quantity}')}");

    _releaseResources(process, availableResourcesCopy);
    executedProcesses.add(processIndex);
    safeSequence.add(process.name);

    history.add(
        "allocated ${process.allocatedResources.map((element) => '${element.name}=${element.quantity}')}");
    history.add(
        "need ${process.needResources.map((element) => '${element.name}=${element.quantity}')}");
    history.add(
        "after ${availableResourcesCopy.map((e) => '${e.name}=${e.quantity}')}");
  }

  void _releaseResources(
      Process process, List<Resource> availableResourcesCopy) {
    List<Resource> allocated = process.allocatedResources;
    for (int i = 0; i < allocated.length; i++) {
      Resource resource =
          availableResourcesCopy.firstWhere((r) => r.name == allocated[i].name);
      resource.quantity += allocated[i].quantity;
    }
  }

  void _getHistory() {
    history.forEach(print);
  }
}
