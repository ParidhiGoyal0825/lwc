@isTest
public class FileUploadControllerTest {

    @isTest
    public static void testSaveFile_Success() {
        String fileContent = 'Test file content';
        String base64Data = EncodingUtil.base64Encode(Blob.valueOf(fileContent));
        String fileName = 'TestFile.txt';
        String contentType = 'text/plain';

        Test.startTest();
        String result = FileUploadController.saveFile(base64Data, fileName, contentType);
        Test.stopTest();

        System.assertEquals('Success', result);

        List<ContentVersion> files = [SELECT Id, Title, PathOnClient FROM ContentVersion WHERE Title = :fileName];
        System.assertEquals(1, files.size());
        System.assertEquals(fileName, files[0].Title);
        System.assertEquals(fileName, files[0].PathOnClient);
    }

    @isTest
    public static void testSaveFile_ErrorHandling() {
        Test.startTest();
        String result = FileUploadController.saveFile(null, null, null);
        Test.stopTest();

        System.assert(result.startsWith('Error:'), 'Expected an error message');
    }
}