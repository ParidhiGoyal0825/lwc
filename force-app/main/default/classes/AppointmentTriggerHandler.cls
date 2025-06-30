public class AppointmentTriggerHandler {
    public static void validateAppointments(List<Appointment__c> newAppointments) {
        try{
        Set<Id> doctorId = new Set<Id>();
        Set<Id> patientId = new Set<Id>();
        Set<Date> dateSet = new Set<Date>();

        
        for (Appointment__c app : newAppointments) {
            if (app.Doctor__c != null && app.Patient__c != null && app.Date__c != null) {
                doctorId.add(app.Doctor__c);
                patientId.add(app.Patient__c);
                dateSet.add(app.Date__c);
            }
        }

        List<Appointment__c> oldAppointments = [
            SELECT Id, Doctor__c, Doctor__r.Name,
                   Patient__c, Patient__r.Name,
                   Date__c
            FROM Appointment__c
            WHERE Doctor__c IN :doctorId
              AND Date__c IN :dateSet
        ];

        Map<Id, Map<Date, Integer>> doctorDateCount = new Map<Id, Map<Date, Integer>>();
        Map<Id, Map<Id, Set<Date>>> patientDoctorDateMap = new Map<Id, Map<Id, Set<Date>>>();
 
        Map<Id, String> doctorNames = new Map<Id, String>();
        Map<Id, String> patientNames = new Map<Id, String>();
        if(!oldAppointments.isEmpty()){
        for (Appointment__c app : oldAppointments) {
            Date d = app.Date__c;

            if (!doctorDateCount.containsKey(app.Doctor__c)) {
                doctorDateCount.put(app.Doctor__c, new Map<Date, Integer>());
            }
            Map<Date, Integer> dateMap = doctorDateCount.get(app.Doctor__c);
            dateMap.put(d, dateMap.containsKey(d) ? dateMap.get(d) + 1 : 1);

           
            if (!patientDoctorDateMap.containsKey(app.Patient__c)) {
                patientDoctorDateMap.put(app.Patient__c, new Map<Id, Set<Date>>());
            }
            Map<Id, Set<Date>> doctorDateSetMap = patientDoctorDateMap.get(app.Patient__c);
            if (!doctorDateSetMap.containsKey(app.Doctor__c)) {
                doctorDateSetMap.put(app.Doctor__c, new Set<Date>());
            }
            doctorDateSetMap.get(app.Doctor__c).add(d);

            
            doctorNames.put(app.Doctor__c, app.Doctor__r.Name);
            patientNames.put(app.Patient__c, app.Patient__r.Name);
        }
        }
        for (Appointment__c app : newAppointments) {
            if (app.Patient__c == null || app.Date__c == null) continue;

            Id docId = app.Doctor__c;
            Id patId = app.Patient__c;
            Date d = app.Date__c;

           
            if (!doctorDateCount.containsKey(docId)) {
                doctorDateCount.put(docId, new Map<Date, Integer>());
            }
            Map<Date, Integer> dateMap = doctorDateCount.get(docId);
            Integer count = dateMap.containsKey(d) ? dateMap.get(d) : 0;

            if (count >= 8) {
                String docName = doctorNames.containsKey(docId) ? doctorNames.get(docId) : 'Unknown';
                app.addError('Appointment cannot be registered because Dr. ' + docName + ' has been booked for the day.');
                continue;
            }

           
            Boolean hasAppointment = false;
            if (patientDoctorDateMap.containsKey(patId)) {
                Map<Id, Set<Date>> doctorDateSetMap = patientDoctorDateMap.get(patId);
                if (doctorDateSetMap.containsKey(docId)) {
                    Set<Date> dateSetForDoctor = doctorDateSetMap.get(docId);
                    if (dateSetForDoctor.contains(d)) {
                        hasAppointment = true;
                    }
                }
            }

            if (hasAppointment) {
                String docName = doctorNames.containsKey(docId) ? doctorNames.get(docId) : 'Unknown';
                String patName = patientNames.containsKey(patId) ? patientNames.get(patId) : 'Unknown';
                app.addError('This appointment cannot be registered because Mr/Mrs ' + patName +
                    ' had already registered an appointment with Dr. ' + docName + ' for ' + d + '.');
                continue;
            }

            
            dateMap.put(d, count + 1);

           
            if (!patientDoctorDateMap.containsKey(patId)) {
                patientDoctorDateMap.put(patId, new Map<Id, Set<Date>>());
            }
            Map<Id, Set<Date>> doctorDateSetMap = patientDoctorDateMap.get(patId);

            if (!doctorDateSetMap.containsKey(docId)) {
                doctorDateSetMap.put(docId, new Set<Date>());
            }
            doctorDateSetMap.get(docId).add(d);
        }
        }catch(Exception e){
            System.debug('error' + e.getMessage());
        }
    }
}