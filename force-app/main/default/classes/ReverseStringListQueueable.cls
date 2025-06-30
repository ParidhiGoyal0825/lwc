public class ReverseStringListQueueable implements Queueable {
    private List<String> inputList;

    public ReverseStringListQueueable(List<String> inputList) {
        this.inputList = inputList;
    }

    public void execute(QueueableContext context) {
        List<String> reversedList = new List<String>();

        for (String s : inputList) {
            reversedList.add(reverseString(s));
        }

        System.debug('Reversed List: ' + reversedList);
    }

    private String reverseString(String s) {
        if (String.isBlank(s)) return s;

        String reversed = '';
        for (Integer i = s.length() - 1; i >= 0; i--) {
            reversed += s.substring(i, i + 1);
        }
        return reversed;
    }
}