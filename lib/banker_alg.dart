import './resource.dart';
import './process.dart';
import './resource.dart';
import './process.dart';

class BankersAlgorithm {
  final List<Resource> availableResources;
  final List<Process> processes;
  late final List<Resource> availableResourcesCopy;

  final List<String> safeSequence = [];
  final List<String> history = [];
  final Set<Process> executedProcesses = Set();

  BankersAlgorithm(this.availableResources, this.processes) {
    availableResourcesCopy = List.from(availableResources);
  }

  void checkIfIsSafeState() {
    if (_isSafeState()) {
      print("Safe state.");
      _getHistory();
    } else {
      print("Unsafe state.");
    }
  }

  bool _isSafeState() {
    int completedProcesses = 0;

    while (completedProcesses < processes.length) {
      Process? currentProcess = _getExecutableProcess();
      if (currentProcess == null) {
        return false;
      }

      _executeProcess(currentProcess);
      completedProcesses++;
    }

    print("Safe sequence: ${safeSequence.join(', ')}");
    return true;
  }

  Process? _getExecutableProcess() {
    for (var process in processes) {
      if (!_processAlreadyExecuted(process) && _isResourceAvailable(process)) {
        return process;
        break;
      }
    }
  }

  bool _processAlreadyExecuted(process) {
    return executedProcesses.contains(process);
  }

  bool _isResourceAvailable(Process process) {
    return process.needResources.every((needResource) =>
        needResource.quantity <=
        availableResourcesCopy
            .firstWhere((resource) => resource.name == needResource.name)
            .quantity);
  }

  void _executeProcess(Process process) {
    history.add('-------------------------------');
    history.add(process.name);
    history.add(
        "current resources: ${availableResourcesCopy.map((e) => '${e.name}=${e.quantity}')}");

    _releaseResources(process);
    executedProcesses.add(process);
    safeSequence.add(process.name);

    history.add(
        "resources allocated ${process.allocatedResources.map((element) => '${element.name}=${element.quantity}')}");
    history.add(
        "resources need ${process.needResources.map((element) => '${element.name}=${element.quantity}')}");
    history.add(
        "new resources ${availableResourcesCopy.map((e) => '${e.name}=${e.quantity}')}");
  }

  void _releaseResources(Process process) {
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
