@isTest
public class AppointmentTriggerHandlerTest {
    @testSetup
    static void setupData() {
        
        Doctor__c doctor = new Doctor__c(Name = 'Dr. Strange');
        insert doctor;

        
        for (Integer i = 0; i < 8; i++) {
            Patient__c tempPatient = new Patient__c(Name = 'Patient ' + i);
            insert tempPatient;

            Appointment__c app = new Appointment__c(
                Doctor__c = doctor.Id,
                Patient__c = tempPatient.Id,
                Date__c = Date.today()
            );
            insert app;
        }
    }

    @isTest
    static void testDoctorAppointmentLimitExceeded() {
        Doctor__c doctor = [SELECT Id FROM Doctor__c LIMIT 1];
        Patient__c newPatient = new Patient__c(Name = 'New Patient A');
        insert newPatient;

        Appointment__c newApp = new Appointment__c(
            Doctor__c = doctor.Id,
            Patient__c = newPatient.Id,
            Date__c = Date.today()
        );

        Test.startTest();
        Database.SaveResult result = Database.insert(newApp, false);
        Test.stopTest();

        System.assert(!result.isSuccess(), 'Should fail because doctor already has 8 appointments.');
        System.assert(result.getErrors()[0].getMessage().contains('has been booked for the day'), 'Error message should mention doctor limit.');
    }

    @isTest
    static void testDuplicatePatientAppointment() {
        Doctor__c doctor = [SELECT Id FROM Doctor__c LIMIT 1];
        Patient__c patient = new Patient__c(Name = 'John Doe');
        insert patient;

        // Insert a valid first appointment
        Appointment__c firstApp = new Appointment__c(
            Doctor__c = doctor.Id,
            Patient__c = patient.Id,
            Date__c = Date.today().addDays(1)
        );
        insert firstApp;

        // Now try to insert a duplicate on the same date
        Appointment__c duplicateApp = new Appointment__c(
            Doctor__c = doctor.Id,
            Patient__c = patient.Id,
            Date__c = Date.today().addDays(1)
        );

        Test.startTest();
        Database.SaveResult result = Database.insert(duplicateApp, false);
        Test.stopTest();

        System.assert(!result.isSuccess(), 'Should fail due to duplicate patient-doctor-date appointment.');
        System.assert(result.getErrors()[0].getMessage().contains('already registered'), 'Error should indicate duplicate appointment.');
    }

    @isTest
    static void testValidAppointment() {
        Doctor__c doctor = [SELECT Id FROM Doctor__c LIMIT 1];
        Patient__c newPatient = new Patient__c(Name = 'New Valid Patient');
        insert newPatient;

        Appointment__c validApp = new Appointment__c(
            Doctor__c = doctor.Id,
            Patient__c = newPatient.Id,
            Date__c = Date.today().addDays(2) // Valid new date
        );

        Test.startTest();
        insert validApp;
        Test.stopTest();

        System.assertNotEquals(null, validApp.Id, 'Valid appointment should be inserted successfully.');
    }
}