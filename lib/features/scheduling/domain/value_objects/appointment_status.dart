enum AppointmentStatus {
  pending,
  confirmed,
  canceled;

  bool get isPending => this == AppointmentStatus.pending;
  bool get isConfirmed => this == AppointmentStatus.confirmed;
  bool get isCanceled => this == AppointmentStatus.canceled;
}
