public class ComplexLogicQueueable implements Queueable {
    private List<String> numList;

    public ComplexLogicQueueable(List<String> numList) {
        this.numList = numList;
    }

    public void execute(QueueableContext context) {
        if (numList == null || numList.isEmpty()) {
            System.debug('No input data provided.');
            return;
        }

        List<String> cleanedNumList = cleanAndNormalize(numList);
        List<String> reversedNumList = reverseStrings(cleanedNumList);
        List<String> uniqueSortedNumList = sortAndDeduplicate(reversedNumList);
        Map<String, Integer> wordLengths = calculateStringLengths(uniqueSortedNumList);
        Map<String, Boolean> palindromes = checkPalindromes(uniqueSortedNumList);

        System.debug('Final Processed Data:');
        for (String s : uniqueSortedNumList) {
            System.debug('String: ' + s + ', Length: ' + wordLengths.get(s) + ', Palindrome: ' + palindromes.get(s));
        }
    }

    private List<String> cleanAndNormalize(List<String> numList) {
        List<String> output = new List<String>();
        for (String s : numList) {
            if (!String.isBlank(s)) {
                output.add(s.trim().toLowerCase());
            }
        }
        return output;
    }

    private List<String> reverseStrings(List<String> numList) {
        List<String> reversed = new List<String>();
        for (String s : numList) {
            reversed.add(reverse(s));
        }
        return reversed;
    }

    private String reverse(String s) {
        String result = '';
        for (Integer i = s.length() - 1; i >= 0; i--) {
            result += s.substring(i, i + 1);
        }
        return result;
    }

    private List<String> sortAndDeduplicate(List<String> numList) {
        Set<String> unique = new Set<String>(numList);
        List<String> sorted = new List<String>();
        sorted.addAll(unique);
        sorted.sort();
        return sorted;
    }

    private Map<String, Integer> calculateStringLengths(List<String> numList) {
        Map<String, Integer> lengths = new Map<String, Integer>();
        for (String s : numList) {
            lengths.put(s, s.length());
        }
        return lengths;
    }

    private Map<String, Boolean> checkPalindromes(List<String> numList) {
        Map<String, Boolean> results = new Map<String, Boolean>();
        for (String s : numList) {
            results.put(s, s == reverse(s));
        }
        return results;
    }
}