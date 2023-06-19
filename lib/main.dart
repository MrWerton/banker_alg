import './banker_alg.dart';
import './resource.dart';
import './process.dart';

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

  bankersAlgorithm.checkIfIsSafeState();
}
