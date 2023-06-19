class Resource {
  String name;
  int quantity;

  Resource(this.name, this.quantity);
}

class Process {
  String name;
  List<Resource> allocatedResources;
  List<Resource> needResources;

  Process(
      {required this.name,
      required this.allocatedResources,
      required this.needResources});
}

class BankersAlgorithm {
  List<Resource> availableResources;
  List<Process> processes;

  BankersAlgorithm(this.availableResources, this.processes);

  bool isSafe() {
    List<bool> isExecuted = List.filled(processes.length, false);
    List<Resource> work = List.from(availableResources);

    List<String> safeSequence = [];
    List<String> currentStatusOfResources = [];
    int completedProcesses = 0;

    while (completedProcesses < processes.length) {
      bool found = false;
      for (int i = 0; i < processes.length; i++) {
        if (!isExecuted[i] && _isResourceAvailable(i, work)) {
          _releaseResources(i, work);
          isExecuted[i] = true;
          safeSequence.add(processes[i].name);
          completedProcesses++;
          found = true;
          String name = processes[i].name;
          print('Processo: $name');

          for (int j = 0; j < work.length; j++) {
            Resource need = processes[i].needResources[j];
            Resource allocated = processes[i].allocatedResources[j];
            Resource resource = work[j];

            Resource previousAvailable =
                Resource(resource.name, resource.quantity - allocated.quantity);
            print('Recurso: ${resource.name}');
            print('Quantidade necessária: ${need.quantity}');
            print('Quantidade alocada: ${allocated.quantity}');

            print(
                'Quantidade disponível anteriomente: ${previousAvailable.quantity}');
            print('Quantidade disponível agora: ${resource.quantity}');
            print('------------------------------');
          }
          break;
        }
      }
      if (!found) {
        return false; // Unsafe state, no process can be executed
      }
    }

    print("Sequencia segura: ${safeSequence.join(', ')}");
    return true;
  }

  bool _isResourceAvailable(int processIndex, List<Resource> work) {
    List<Resource> need = processes[processIndex].needResources;
    for (int i = 0; i < need.length; i++) {
      if (need[i].quantity > work[i].quantity) {
        return false;
      }
    }
    return true;
  }

  void _releaseResources(int processIndex, List<Resource> work) {
    List<Resource> allocated = processes[processIndex].allocatedResources;
    for (int i = 0; i < allocated.length; i++) {
      work[i].quantity += allocated[i].quantity;
    }
  }
}

void main() {
  List<Resource> availableResources = [
    Resource('keyboard', 1),
    Resource('speakers', 5),
    Resource('monitor', 2),
  ];

  List<Process> processes = [
    Process(
      name: 'web',
      allocatedResources: [
        Resource('keyboard', 0),
        Resource('speakers', 1),
        Resource('monitor', 3),
      ],
      needResources: [
        Resource('keyboard', 1),
        Resource('speakers', 6),
        Resource('monitor', 0),
      ],
    ),
    Process(
      name: 'video',
      allocatedResources: [
        Resource('keyboard', 2),
        Resource('speakers', 0),
        Resource('monitor', 0),
      ],
      needResources: [
        Resource('keyboard', 0),
        Resource('speakers', 0),
        Resource('monitor', 4),
      ],
    ),
    Process(
      name: 'editor',
      allocatedResources: [
        Resource('keyboard', 3),
        Resource('speakers', 0),
        Resource('monitor', 2),
      ],
      needResources: [
        Resource('keyboard', 0),
        Resource('speakers', 2),
        Resource('monitor', 0),
      ],
    ),
    Process(
      name: 'music',
      allocatedResources: [
        Resource('keyboard', 2),
        Resource('speakers', 1),
        Resource('monitor', 1),
      ],
      needResources: [
        Resource('keyboard', 1),
        Resource('speakers', 1),
        Resource('monitor', 2),
      ],
    ),
  ];

  BankersAlgorithm bankersAlgorithm = BankersAlgorithm(
    availableResources,
    processes,
  );

  if (bankersAlgorithm.isSafe()) {
    print("Safe state.");
  } else {
    print("Unsafe state.");
  }
}
