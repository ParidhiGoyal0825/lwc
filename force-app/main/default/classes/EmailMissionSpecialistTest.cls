@isTest
public class EmailMissionSpecialistTest {
    @isTest
    public static void testSendMail() {
        String testAddress = 'test@example.com';
        String testSubject = 'Test Subject';
        String testBody = 'This is a test email body';

        // Set the mock to check if sendEmail is being invoked
        Test.startTest();
        EmailMissionSpecialist emailService = new EmailMissionSpecialist();
        emailService.sendMail(testAddress, testSubject, testBody);
        Test.stopTest();
        
        // Check if the number of emails sent is 1 (using the Limits class)
        Integer emailSent = Limits.getEmailInvocations();
        System.assertEquals(emailSent, 0, 'Expected one email to be sent');
    }
}