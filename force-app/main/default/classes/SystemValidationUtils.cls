/**
* Utility class to handle different "purpose" build validations.
*
* @author   Peter Guest
* @since    2019-03-07
**/
public class SystemValidationUtils {

    public enum type { RSA_ID_NUMBER }

    /**
    * Main method to execute a validation.
    * 
    * @param    inputType   The type of validation to be performed.
    * @param    inputValue  The value to be valued.
    * @return   Boolean     The outcome of the validation.
    **/
    public static Boolean validate(SystemValidationUtils.type inputType, Object inputValue) {

        //South African ID Number
        if(inputType == type.RSA_ID_NUMBER)  {
            return rsaIdNumber(inputValue); 
        }

        return false;
    }

    /**
    * Validates that a value is a South African ID Number. 
    * 
    * @param    inputValue  The value to be valued.
    * @return   Boolean     The outcome of the validation.
    **/
    private static Boolean rsaIdNumber(Object inputValue) {
        
        //Get this check out the way...
        if(inputValue == null) {
            return false;
        }

        //Convert object to a string.
        String identificationNumber = String.valueOf(inputValue).trim();

        //Make sure the identifier is 13 characters and only contains digits.
        if(identificationNumber.length() != 13 || !identificationNumber.isNumeric()) {
            return false;
        }   

        //Make sure we have valid month and day combination.
        String monthDayPortion = identificationNumber.mid(2,4);
        Pattern regexPattern = Pattern.compile('(\\d{2})(\\d{2})');
        Matcher regexMatcher = regexPattern.matcher(monthDayPortion);
        
        //Verify matches.
        if(regexMatcher.matches()) {

            //Month (1-12)
            if(Integer.valueOf(regexMatcher.group(1)) > 12 || Integer.valueOf(regexMatcher.group(1)) < 1) {
                return false;
            }

            //Day (1-31)
            if(Integer.valueOf(regexMatcher.group(2)) > 31 || Integer.valueOf(regexMatcher.group(2)) < 1) {
                return false;
            }
        }

        //Make sure citizenship is either 1 or 0
        if(Integer.valueOf(identificationNumber.mid(10,1)) != 0 && Integer.valueOf(identificationNumber.mid(10,1)) != 1) {
            return false;
        } 

        Long sumOddNumbers = 0;
        Long sumEvenNumbers = 0;
        String evenNumbersCombined = '';

        //Loop over each character in string to get value and numerical value. 
        for(Integer position = 0; position < identificationNumber.length()-1; position++) {

            //Sum "odd" numbers.
            if(Math.mod(position, 2) == 0) {     
                sumOddNumbers += Integer.valueOf(identificationNumber.mid(position, 1));
            }
            //Combined "even" numbers into a string.
            else {
                evenNumbersCombined += identificationNumber.mid(position, 1);
            }
        }
        
        System.debug(sumOddNumbers);
        System.debug(evenNumbersCombined);

        //Multiple the combined even numbers by 2.
        Long evenNumbersMultiplied = Integer.valueOf(evenNumbersCombined) * 2;
        
        System.debug(evenNumbersMultiplied);

        //Add new "even" numbers together after multiplied.
        for(Integer position = 0; position < String.valueOf(evenNumbersMultiplied).length(); position++) {
            sumEvenNumbers += Integer.valueOf(String.valueOf(evenNumbersMultiplied).mid(position, 1));
        }
        
        //Calculate check digit based on total sizes.
        Long sumOddAndEvenNumbers = sumEvenNumbers + sumOddNumbers;        
        Long subtractionTotal = 10 - Integer.valueOf((sumOddAndEvenNumbers > 9 ? String.valueOf(sumOddAndEvenNumbers).mid(1,1) : String.valueOf(sumOddAndEvenNumbers)));
        String checkdigit = subtractionTotal > 9 ? String.valueOf(subtractionTotal).mid(1,1) : String.valueOf(subtractionTotal);
        
        //Check if the digits match.
        Boolean result = (identificationNumber.mid(identificationNumber.length()-1,1) == checkdigit) ? true : false;

        //Final outcome.
        return result;
        
        
    }
}