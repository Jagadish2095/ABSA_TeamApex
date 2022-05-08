/**
 * @description       : SupervisedScreenControllerTest
 * @author            : Vinod.Thupakula@absa.africa
 * @group             : 
 * @last modified on  : 2021-11-16
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
@IsTest
public class SupervisedScreenControllerTest {

    @IsTest public static  void UserDetailsTest(){
        Test.startTest();
        User u = SupervisedScreenController.getUserDetails(Userinfo.getUserId());
        Test.stopTest();
        system.assertEquals(u != null, true);
    }
}