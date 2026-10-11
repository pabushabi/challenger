enum EventFormAction {
  save,
  delete,
}

class EventFormResult {
  const EventFormResult.save(this.values) : action = EventFormAction.save;

  const EventFormResult.delete()
      : action = EventFormAction.delete,
        values = null;

  final EventFormAction action;
  final Map<String, String>? values;
}
