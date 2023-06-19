class Resource {
  String name;
  int quantity;

  Resource({required this.name, required this.quantity});
}

class Process {
  late String name;
  late List<int> requiredResources;
  late List<int> allocatedResources;

  Process(
      {required this.name,
      required this.requiredResources,
      required this.allocatedResources});
}

class Banker {
  List<Resource> availableResources;
  List<Process> processes;

  Banker({required this.availableResources, required this.processes});

  void checkIfIsSafeState() {
    List<Resource> availableResourcesTemp = _getCopyAvailableResources();
    List<List<int>> allocatedResourcesTemp = _getCopyAllocatedResources();
    List<List<int>> requiredResourcesTemp = _getCopyRequiredResources();

    List<bool> completedProcesses = _completedProcess();
    List<bool> safeProcesses = List.filled(processes.length, true);

    for (var process in processes) {
      int processIndex = processes.indexOf(process);

      bool checkIfCurrentProcessIsCompleted = completedProcesses[processIndex];

      if (!checkIfCurrentProcessIsCompleted) {
        bool allocatedResources = _allocateResourcesAndMarkProcessAsCompleted(
            completedProcesses,
            availableResourcesTemp,
            allocatedResourcesTemp,
            requiredResourcesTemp,
            processIndex);

        if (!allocatedResources) {
          safeProcesses[processIndex] = false;
          print('Process ${process.name} is not safe');
        } else {
          print('Process ${process.name} is safe');
        }
      }
    }

    for (var process in processes) {
      int processIndex = processes.indexOf(process);

      if (!safeProcesses[processIndex]) {
        _deallocateResources(processIndex, availableResourcesTemp,
            allocatedResourcesTemp, requiredResourcesTemp);
      }
    }
  }

  bool _allocateResourcesAndMarkProcessAsCompleted(
      List<bool> completedProcesses,
      List<Resource> availableResourcesTemp,
      List<List<int>> allocatedResourcesTemp,
      List<List<int>> requiredResourcesTemp,
      int processIndex) {
    if (!completedProcesses[processIndex] &&
        _checkIfHasResourcesAvailableForProcess(
            processIndex, availableResourcesTemp, requiredResourcesTemp)) {
      _allocateResourcesToProcess(processIndex, availableResourcesTemp,
          allocatedResourcesTemp, requiredResourcesTemp);
      _markProcessAsCompleted(processIndex, completedProcesses);
      return true;
    }

    return false;
  }

  bool _checkIfHasResourcesAvailableForProcess(
      int processIndex,
      List<Resource> availableResourcesTemp,
      List<List<int>> requiredResourcesTemp) {
    for (int resourceIndex = 0;
        resourceIndex < availableResourcesTemp.length;
        resourceIndex++) {
      int requiredResources =
          requiredResourcesTemp[processIndex][resourceIndex];
      if (requiredResources > availableResourcesTemp[resourceIndex].quantity) {
        return false;
      }
    }
    return true;
  }

  void _allocateResourcesToProcess(
      int processIndex,
      List<Resource> availableResourcesTemp,
      List<List<int>> allocatedResourcesTemp,
      List<List<int>> requiredResourcesTemp) {
    for (int resourceIndex = 0;
        resourceIndex < availableResourcesTemp.length;
        resourceIndex++) {
      int requiredResources =
          requiredResourcesTemp[processIndex][resourceIndex];
      availableResourcesTemp[resourceIndex].quantity -= requiredResources;
      allocatedResourcesTemp[processIndex][resourceIndex] += requiredResources;
    }
  }

  void _deallocateResources(
      int processIndex,
      List<Resource> availableResourcesTemp,
      List<List<int>> allocatedResourcesTemp,
      List<List<int>> requiredResourcesTemp) {
    for (int resourceIndex = 0;
        resourceIndex < availableResourcesTemp.length;
        resourceIndex++) {
      int allocatedResources =
          allocatedResourcesTemp[processIndex][resourceIndex];
      availableResourcesTemp[resourceIndex].quantity += allocatedResources;
      allocatedResourcesTemp[processIndex][resourceIndex] = 0;
    }
  }

  void _markProcessAsCompleted(
      int processIndex, List<bool> completedProcesses) {
    completedProcesses[processIndex] = true;
  }

  List<Resource> _getCopyAvailableResources() {
    return availableResources
        .map((resource) =>
            Resource(name: resource.name, quantity: resource.quantity))
        .toList();
  }

  List<List<int>> _getCopyAllocatedResources() {
    return processes
        .map((process) => List<int>.from(process.allocatedResources))
        .toList();
  }

  List<List<int>> _getCopyRequiredResources() {
    return processes
        .map((process) => List<int>.from(process.requiredResources))
        .toList();
  }

  List<bool> _completedProcess() => List.filled(processes.length, false);
}

void main() {
  Resource keyboard = Resource(name: 'Keyboard', quantity: 1);
  Resource monitor = Resource(name: 'Monitor', quantity: 2);
  Resource mouse = Resource(name: 'Mouse', quantity: 1);

  List<Resource> availableResources = [keyboard, monitor, mouse];

  Process process1 = Process(
      name: 'Text Editor',
      requiredResources: [1, 3, 1],
      allocatedResources: [0, 0, 0]);
  Process process2 = Process(
      name: 'Music Player',
      requiredResources: [0, 1, 0],
      allocatedResources: [0, 0, 0]);
  Process process3 = Process(
      name: 'Image Viewer',
      requiredResources: [2, 1, 1],
      allocatedResources: [0, 0, 0]);
  Process process4 = Process(
      name: 'Video Player',
      requiredResources: [1, 2, 0],
      allocatedResources: [0, 0, 0]);
  Process process5 = Process(
      name: 'Web Browser',
      requiredResources: [1, 1, 1],
      allocatedResources: [0, 0, 0]);

  List<Process> processes = [process1, process2, process3, process4, process5];

  Banker banker =
      Banker(availableResources: availableResources, processes: processes);
  banker.checkIfIsSafeState();
}
