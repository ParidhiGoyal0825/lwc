public with sharing class EmailController {
    @AuraEnabled
    public static String sendEmail(String to, String cc, String bcc, String subject, String body, String jsonFiles) {
        

        try {
            // Deserialize the JSON data 
            List<AttachmentWrapper> attachments = 
            (List<AttachmentWrapper>) JSON.deserialize(jsonFiles, List<AttachmentWrapper>.class);

            // helper method to prepare the attachments
            List<Messaging.EmailFileAttachment> emailAttachments = prepareAttachments(attachments);
            
            // Create the email message
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(to.split(','));  

            if (cc != null && cc != '') {
                mail.setCcAddresses(cc.split(','));
            }
            if (bcc != null && bcc != '') {
                mail.setBccAddresses(bcc.split(','));
            }

            mail.setSubject(subject);
            mail.setHtmlBody(body);
            mail.setSenderDisplayName('Salesforce Mailer');

            // Attach files to the email
            mail.setFileAttachments(emailAttachments);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

            return 'Success';
        } catch (Exception e) {
            System.debug(e.getLineNumber());
            throw new AuraHandledException('Email Can\'t be sent! ' + e.getMessage());
        }
    }

    // Helper method to prepare the attachments for the email
    private static List<Messaging.EmailFileAttachment> prepareAttachments(List<AttachmentWrapper> attachments) {
        List<Messaging.EmailFileAttachment> emailAttachments = new List<Messaging.EmailFileAttachment>();

        for (AttachmentWrapper file : attachments) {
            Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();

            // Set the base64 encoded data and other details
            emailAttachment.setFileName(file.fileName);           
            emailAttachment.setContentType(file.fileType);       
            emailAttachment.setBody(EncodingUtil.base64Decode(file.base64Data));  // Decode base64 content

            // Add attachment to the list
            emailAttachments.add(emailAttachment);
        }

        return emailAttachments;
    }

    public class AttachmentWrapper {
        public String id;           
        public String fileName;     
        public String fileType;    
        public String base64Data;   
    }
}