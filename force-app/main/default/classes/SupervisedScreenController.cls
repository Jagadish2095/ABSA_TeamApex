/**
 * @description       : SupervisedScreenController
 * @author            : Vinod.Thupakula@absa.africa
 * @group             : 
 * @last modified on  : 11-16-2021
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
public class SupervisedScreenController {

    /**@description get User Details
        * @param userId (Id)
        * @return User
        *  @author : Divya
    */
    @AuraEnabled
	public static user getUserDetails(String userId)
    {
         UsersSelector selector =new UsersSelector();
         return selector.selectById(userId);
    }
}