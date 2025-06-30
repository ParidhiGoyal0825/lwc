trigger AppointmentTrigger on Appointment__c (before insert, before update) {
          AppointmentTriggerHandler.validateAppointments(Trigger.new);
}