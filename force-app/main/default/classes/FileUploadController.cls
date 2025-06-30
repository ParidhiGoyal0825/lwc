public class FileUploadController {
    @AuraEnabled
    public static String saveFile(String base64Data, String fileName, String contentType) {
        try {
            // Create a ContentVersion object to store the file
            ContentVersion contentVersion = new ContentVersion();
            contentVersion.Title = fileName;
            contentVersion.PathOnClient = fileName;
            contentVersion.VersionData = EncodingUtil.base64Decode(base64Data);

            // Insert the ContentVersion
            insert contentVersion;

            // Return success message
            return 'Success';
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}