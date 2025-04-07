import 'package:affinity/core/error/failures.dart';
import 'package:affinity/core/usecase/usecase.dart';
import 'package:affinity/features/blog/domain/entities/event.dart';
import 'package:affinity/features/blog/domain/repositories/event_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllEvents implements UseCase<List<Event>, NoParams> {
  final EventRepository eventRepository;
  GetAllEvents(this.eventRepository);

  @override
  Future<Either<Failure, List<Event>>> call(NoParams params) async {
    return await eventRepository.getAllEvents();
  }
}
