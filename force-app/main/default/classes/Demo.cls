public class Demo {
   public static void primeDigits(Integer a) {
        String numStr = String.valueOf(a);
        List<String> primeDigitsList = new List<String>();
        Set<String> primeSet = new Set<String>{'2', '3', '5', '7'};  

        for (Integer i = 0; i < numStr.length(); i++) {
            String digit = numStr.substring(i, i + 1);
            if (primeSet.contains(digit)) {
                primeDigitsList.add(digit);
            }
        }

        System.debug(primeDigitsList);
    }
     }