@isTest
public class EmailControllerTest {

    @isTest
    static void testSendEmail_Success() {
        String to = 'testuser@example.com';
        String cc = 'ccuser@example.com';
        String bcc = 'bccuser@example.com';
        String subject = 'Test Subject';
        String body = '<p>This is a test email body</p>';

        List<EmailController.AttachmentWrapper> attachments = new List<EmailController.AttachmentWrapper>();
        EmailController.AttachmentWrapper file = new EmailController.AttachmentWrapper();
        file.id = '001XXXXXXX';
        file.fileName = 'Test.txt';
        file.fileType = 'text/plain';
        file.base64Data = EncodingUtil.base64Encode(Blob.valueOf('Test file content'));
        attachments.add(file);

        String jsonAttachments = JSON.serialize(attachments);

        Test.startTest();
        String result = EmailController.sendEmail(to, cc, bcc, subject, body, jsonAttachments);
        Test.stopTest();

        System.assertEquals('Success', result);
    }

    @isTest
    static void testSendEmail_NoCcBcc() {
        String to = 'testuser@example.com';
        String subject = 'Subject Only';
        String body = 'Body Only';

        List<EmailController.AttachmentWrapper> attachments = new List<EmailController.AttachmentWrapper>();
        EmailController.AttachmentWrapper file = new EmailController.AttachmentWrapper();
        file.fileName = 'NoCCBCC.txt';
        file.fileType = 'text/plain';
        file.base64Data = EncodingUtil.base64Encode(Blob.valueOf('Content here'));
        attachments.add(file);

        String jsonAttachments = JSON.serialize(attachments);

        Test.startTest();
        String result = EmailController.sendEmail(to, null, '', subject, body, jsonAttachments);
        Test.stopTest();

        System.assertEquals('Success', result);
    }

    @isTest
static void testSendEmail_InvalidBase64() {
    String to = 'testuser@example.com';
    String subject = 'Invalid Base64';
    String body = 'This should trigger an exception';

    List<EmailController.AttachmentWrapper> attachments = new List<EmailController.AttachmentWrapper>();
    EmailController.AttachmentWrapper file = new EmailController.AttachmentWrapper();
    file.fileName = 'Invalid.txt';
    file.fileType = 'text/plain';
    file.base64Data = '!!not-base64!!'; // Intentionally invalid
    attachments.add(file);

    String jsonAttachments = JSON.serialize(attachments);

    Boolean exceptionThrown = false;
    Test.startTest();
    try {
        EmailController.sendEmail(to, null, null, subject, body, jsonAttachments);
    } catch (Exception e) {
        exceptionThrown = true;
        
    }
    Test.stopTest();

    System.assert(exceptionThrown, 'Expected exception due to invalid base64 input');
}

}