public class AccIdValidationHelper {
    public static void validateAccId(Account acc){
        
        String idNumber  = acc.ID_Number__pc;
        //System.debug('idNumber '+acc.ID_Number__pc);
        //System.debug('acc.ID_Number__pc '+idNumber.length());
        if(idNumber != null && idNumber.length() == 13){
            if(acc.PersonBirthdate != null && acc.Gender__pc != '' && acc.Gender__pc != null && acc.Gender__pc != '' && acc.Country_of_Citizenship__c != null && acc.Country_of_Citizenship__c != ''){
                Date dob = acc.PersonBirthdate;
                System.debug('acc '+dob);
                if(dob != null) {
                    System.debug(dob.day()+' == '+dob.month()+' == '+dob.year());
                    Integer dy = dob.day(); //<= 9 ? Integer.valueOf('0'+String.valueOf(dob.day())) : dob.day();
                    Integer mon = dob.month(); //<= 9 ? Integer.valueOf('0'+String.valueOf(dob.month())) : dob.month();
                    Integer yr = dob.year();
                    String dySTR = String.valueOf(dy);
                    String monSTR = String.valueOf(mon);
                    String yrSTR = String.valueOf(yr).subString(2,4);
                    
                    if(mon <=9){
                        monSTR = '0'+monSTR;
                    }
                    if(dy <=9){
                        dySTR = '0'+dySTR;
                    }
                    
                    String finalDOBExpected =yrSTR+monSTR+dySTR; ///String.valueOf(dy)+String.valueOf(mon)+String.valueOf(yr);
                    System.debug('finalDOBExpected '+finalDOBExpected);
                    String finalDOBActual = idNumber.substring(0,6);
                    System.debug('finalDOBActual '+finalDOBActual);
                    if(finalDOBExpected != finalDOBActual){
                        System.debug('INN');
                        acc.ID_Number__pc.addError('Given details is incorrect, Please try again.');
                    }
                }
                
                
                String gender = acc.Gender__pc;
                System.debug('gender '+gender );
                
                if(gender != null) {
                    String ssss = idNumber.substring(6,10);
                    System.debug('ssss '+ssss);
                    if(gender == 'Male'){
                        if(Integer.valueOf(ssss) > 4999 && Integer.valueOf(ssss) < 10000){
                            
                        }else{
                            System.debug('INN');
                            acc.ID_Number__pc.addError('Given details is incorrect, Please try again.');
                        }
                    }
                    if(gender == 'Female'){
                        if(Integer.valueOf(ssss) > 0 && Integer.valueOf(ssss) < 5000){
                            
                        }else{
                            System.debug('INN');
                            acc.ID_Number__pc.addError('Given details is incorrect, Please try again.');
                        }
                    }
                }
                
                List<String> citizenShipList = new List<String>();
                String citizenShip = acc.Country_of_Citizenship__c;
                String actualCitizenShip = idNumber.substring(10,11);
                
                System.debug('citizenShip '+citizenShip);
                System.debug('actualCitizenShip '+actualCitizenShip);
                if(citizenShip != '' && citizenShip != null){
                    citizenShipList.addAll(citizenShip.split(';'));
                }
                String citizenShipExpected = '';
                if(citizenShipList.size() > 0){
                    citizenShipExpected = citizenShipList[0];
                }
                
                if(citizenShipExpected == 'South Africa'){
                    if(actualCitizenShip == '0'){
                        
                    }else{
                        System.debug('INN');
                        acc.ID_Number__pc.addError('Given details is incorrect, Please try again.');
                    }
                }else{
                    if(actualCitizenShip == '1'){
                        
                    }else{
                        System.debug('INN');
                        acc.ID_Number__pc.addError('Given details is incorrect, Please try again.');
                    }
                }
                String A = idNumber.substring(11,12);
                /*if(A != '8' && A != '9' ){
System.debug('INN');
acc.ID_Number__pc.addError('Given details is incorrect, Please try again.');
}*/
                //  2704014800085
                
                String controlDigit = idNumber.substring(12,13);
                System.debug('controlDigit '+controlDigit);
                System.debug('ODD NUMBERS '+Integer.valueOf(idNumber.substring(0,1))+' '+Integer.valueOf(idNumber.substring(2,3))+' '+Integer.valueOf(idNumber.substring(4,5))+' '+Integer.valueOf(idNumber.substring(6,7))+' '+Integer.valueOf(idNumber.substring(8,9))+' '+Integer.valueOf(idNumber.substring(10,11)));
                Integer sumOfOdd = Integer.valueOf(idNumber.substring(0,1)) + Integer.valueOf(idNumber.substring(2,3)) + Integer.valueOf(idNumber.substring(4,5)) + Integer.valueOf(idNumber.substring(6,7)) + Integer.valueOf(idNumber.substring(8,9)) + Integer.valueOf(idNumber.substring(10,11));
                System.debug('sumOfOdd '+sumOfOdd);
                
                String evenNumbers = idNumber.substring(1,2) + idNumber.substring(3,4) + idNumber.substring(5,6)  +idNumber.substring(7,8) +idNumber.substring(9,10) + idNumber.substring(11,12); //Integer.valueOf(idNumber.substring(1,2) + idNumber.substring(3,4) + idNumber.substring(5,6) + idNumber.substring(6,7) + idNumber.substring(9,10) + idNumber.substring(11,12)) ;
                System.debug('evenNumbers '+evenNumbers);
                
                Integer multiplyOfEvenby2 = Integer.valueOf(evenNumbers) * 2;
                String multiplyOfEvenby2STR = String.valueOf(multiplyOfEvenby2);
                System.debug('multiplyOfEvenby2STR '+multiplyOfEvenby2STR);
                
                
                Integer evnDigSum = 0;//Integer.valueOf(multiplyOfEvenby2STR.substring(0,1)) + Integer.valueOf(multiplyOfEvenby2STR.substring(1,2)) + Integer.valueOf(multiplyOfEvenby2STR.substring(2,3)) + Integer.valueOf(multiplyOfEvenby2STR.substring(3,4)) + Integer.valueOf(multiplyOfEvenby2STR.substring(4,5)) + Integer.valueOf(multiplyOfEvenby2STR.substring(5,6)) +Integer.valueOf(multiplyOfEvenby2STR.substring(6,7));
                for(Integer i=0 ; i < multiplyOfEvenby2STR.length(); i++){
                    evnDigSum += Integer.valueOf(multiplyOfEvenby2STR.substring(i,i+1)); 
                }
                Integer result = sumOfOdd + evnDigSum;
                System.debug('sumOfOdd '+sumOfOdd);
                System.debug('evnDigSum '+evnDigSum);
                System.debug('result '+result);
                //Integer calculatedControlDigit = math.mod(result, 10);
                String resultSTR = String.valueOf(result);
                String tempStr = resultSTR.substring(1,2);
                Integer secondDigitOfResult = Integer.valueOf(tempStr);
                Integer calculatedControlDigit = 10 - secondDigitOfResult;
                
                System.debug('calculatedControlDigit '+calculatedControlDigit);
                calculatedControlDigit = calculatedControlDigit == 10 ? 0 : calculatedControlDigit;
                System.debug('calculatedControlDigit AFTER '+calculatedControlDigit);
                if(calculatedControlDigit != Integer.valueOf(controlDigit)){
                    System.debug('INN');
                    acc.ID_Number__pc.addError('Given details is incorrect, Please try again.');
                }
                /*
* String abc = '8804250435085';
System.debug('0-6 '+abc.subString(0,1));
System.debug('6-10 '+abc.subString(2,3));
System.debug('10-11 '+abc.subString(4,5));
System.debug('11-112 '+abc.subString(6,7));
System.debug('11-112 '+abc.subString(8,9));
System.debug('11-112 '+abc.subString(10,11));
* 
* String abc = '9623410332123';
System.debug('0-6 '+abc.subString(0,6));
System.debug('6-10 '+abc.subString(6,10));
System.debug('10-11 '+abc.subString(10,11));
System.debug('11-112 '+abc.subString(11,12));
var dd = d.getDate();
var mm = d.getMonth() + 1; // Since getMonth() returns month from 0-11 not 1-12
if (mm == 1 || mm == 2 || mm == 3 || mm == 4 || mm == 5 || mm == 6 ||mm == 7 ||mm == 8 ||mm == 9)
{
mm = "0" + mm;
}
if (dd == 1 || dd == 2 || dd == 3 || dd == 4 || dd == 5 || dd == 6 ||dd == 7 ||dd == 8 ||dd == 9)
{
dd = "0" + dd;
}
*/
            }
            
        }else{
            System.debug('IN ELSE');
            acc.ID_Number__pc.addError('Given details is incorrect, Please try again.');
        }
        
    } 
}