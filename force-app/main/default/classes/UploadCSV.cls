public class UploadCSV {
    public static void getFile(){
        String contentDocumentId = '069Qy00000DXNKvIAP';

        ContentVersion cv = [
            SELECT VersionData
            FROM ContentVersion
            WHERE ContentDocumentId = :contentDocumentId
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];

        Blob fileBlob = cv.VersionData;
        String fileBody = fileBlob.toString();

        // Custom line splitting without regex
        List<String> lines = new List<String>();
        String currentLine = '';
        Integer maxLines = 1000; // Prevent CPU limit issues

        for (Integer i = 0; i < fileBody.length(); i++) {
            String ch = fileBody.substring(i, i + 1);
            if (ch == '\n') {
                lines.add(currentLine.replace('\r', ''));
                currentLine = '';
                if (lines.size() >= maxLines) break; // Stop early
            } else {
                currentLine += ch;
            }
        }
        if (!String.isBlank(currentLine) && lines.size() < maxLines) {
            lines.add(currentLine.replace('\r', ''));
        }

        // Parse into postal map
        Map<String, Map<String, String>> postalMap = new Map<String, Map<String, String>>();
        for (Integer i = 1; i < lines.size(); i++) {
            List<String> cols = parseCSVLine(lines[i]);
            if (cols.size() >= 3) {
                String zip = cols[0].trim();
                String city = cols[1].trim();
                String state = cols[2].trim();
                postalMap.put(zip, new Map<String, String>{
                    'City' => city,
                    'State' => state
                });
            }
        }

        
        System.debug(postalMap);
    }

    private static List<String> parseCSVLine(String line) {
        List<String> result = new List<String>();
        Boolean inQuotes = false;
        String value = '';
        for (Integer i = 0; i < line.length(); i++) {
            String c = line.substring(i, i + 1);
            if (c == '"') {
                inQuotes = !inQuotes;
            } else if (c == ',' && !inQuotes) {
                result.add(value.trim());
                value = '';
            } else {
                value += c;
            }
        }
        result.add(value.trim());
        return result;
    }
}