/*
 * Class for getting current user detail 
 * @author chandra
 * @created 2019-11-16
 */
public class CurrentUserInfoCtrl {
    @AuraEnabled 
    public static user fetchUser(){
        User u = [select id,FirstName from User where id =: userInfo.getUserId()];
        return u;
    }
}