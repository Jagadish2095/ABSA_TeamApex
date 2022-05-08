/**
* Apex extension class for the WeatherBasedOnLocation
*
* @author  Tracy de Bruin : CloudSmiths
* @since   2020-01-28
*
**/
public class WeatherLocationExt {
    
    /*Set location
     * 
    * @param  None
    * @return String
    */
    @AuraEnabled
    public static String getLoggedInUserLocation() {
        
        String UserCity = 'Johannesburg';
        User loggedInUser = new UsersSelector().selectById(UserInfo.getUserId());        
        
        if(loggedInUser.Weather_City__c != null) {
            UserCity = loggedInUser.Weather_City__c;
        } 
        
        return UserCity;
    }
}