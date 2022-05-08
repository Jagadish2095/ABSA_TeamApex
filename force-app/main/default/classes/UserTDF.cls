/**
 * @description       : Class used to create User records for test classes.
 * @author            : robertml@absa.africa
 * @last modified on  : 2021-06-29
 * @last modified by  : robertml@absa.africa
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   2021-06-18   robertml@absa.africa   Initial Version
 **/
@isTest
public with sharing class UserTDF {
	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-18
	 **/
	public UserTDF() {
	}
	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-18
	 * @param profile
	 * @param name
	 * @param email
	 * @return User
	 **/
	public static User addUser(String profile, String name, String email) {
		User usr = new User();
		String uniqueUserName = name + DateTime.now().getTime() + '@absa2.com';
		List<Profile> profileList = new List<Profile>();
		profileList = [SELECT Id FROM Profile WHERE Name = :profile LIMIT 1];
		Profile p = new Profile();
		if (profileList.size() > 0) {
			P = profileList.get(0);
			usr.Alias = (name + 'aliaslen').left(7);
			usr.Email = email;
			usr.EmailEncodingKey = 'UTF-8';
			usr.LastName = name;
			usr.LanguageLocaleKey = 'en_US';
			usr.LocaleSidKey = 'en_US';
			usr.ProfileId = p.Id;
			usr.TimeZoneSidKey = 'Africa/Johannesburg';
			usr.UserName = uniqueUserName;
			usr.MobilePhone = '0821234567';
			insert usr;
		}
		return usr;
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-18
	 * @param email
	 * @return User
	 **/
	public static User getUser(String email) {
		User usr = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add(email);
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == email) {
					usr = u;
					break;
				}
			}
			return usr;
		} else {
			return null;
		}
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-18
	 * @param userEmails
	 * @return List<User>
	 **/
	public static List<User> getUserList(Set<String> userEmails) {
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		return userList;
	}
}