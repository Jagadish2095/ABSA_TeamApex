/**
 * Apex Enterprise Design Patterns
 * @description Selector Layer for User objects
 *
 * @author  Kyle Alexander
 * @since   2018-07-26
 */
public class UsersSelector extends fflib_SObjectSelector
{
	//MANDATORY ABSTRACT METHODS - START
	/**
	 * @description getSObjectType description
	 *
	 * @return Return Schema.SObjectType: Return description
	 */
	public Schema.SObjectType getSObjectType() {
		return User.sObjectType;
	}
	/**
	 * @description getSObjectFieldList description
	 *
	 * @return Return List<Schema.SObjectField>: Return description
	 */
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			User.id,
			User.name,
			User.email,
			User.AB_Number__c,
			User.EmployeeNumber,
			User.SiteCode__c,
			User.IsFit__c,
			User.IsSupervised__c,
			User.Advisor_Code__c,
			User.BRID__c,
			User.Profile.Name
		};
	}
	//MANDATORY ABSTRACT METHODS - END

	//get cases by id's
	/**
	 * @description selectById description
	 *
	 * @param idSet (Set<Id>): idSet
	 * @return Return List<User>: Return description
	 */
	public List<User> selectById(Set<Id> idSet) {
		return (List<User>) selectSObjectsById(idSet);
	}

	//CUSTOM SELECTORS - START
	
	//MANDATORY ABSTRACT METHODS - END

	/**
	 * @description Returns a User based on a specific User Id
	 *
	 * @param userId    The SF Id of the User
	 *
	 * @return  User    The User object record
	 */
	public User selectById(Id userId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('LastName')
				.selectField('FirstName')
				.selectField('IsActive')
				.selectField('AB_Number__c')
				.selectField('Agent_ID__c')
				.selectField('Email')
				.selectField('EmployeeNumber') //Added by Gulafsha
				.selectField('SiteCode__c') //Added by Muvhuso
				.selectField('SiteType__c') //Added by Muvhuso
				.selectField('Teller_Operator_Code__c') // Added by Muvhuso
				.selectField('Division__c') //Added by EMONGWE
				.selectField('Supervisor__c') //Added by EMONGWE
				.selectField('City')
				.selectField('Virtual_Chanel_User__c')// Added By Sipho
				.selectField('Weather_City__c')
				.selectField('Teller_Operator_Code__c')
				.selectField('MobilePhone')
				.selectField('Title') // added by Masechaba Maseli for document generation
				.selectField('LastName')
				.selectField('Supervisor__c') //Lulu by Rankwe
				.selectField('EmployeeNumber')
				.selectField('Address')
				.selectField('Advisor_Code__c') //Added by chenna
				.selectField('AIMS_Code__c') //Added by chenna
				.selectField('Liberty_Code__c') //Added by chenna
				.selectField('Sanlam_Code__c') //Added by chenna
				.selectField('Momentum_Code__c') //Added by chenna
				.selectField('Name') //Added by chenna
				.selectField('Profile.Name') //Added By Gulafsha
				.selectField('userrole.name') //Added By Poulami
				.selectField('Level_1__c')
				.selectField('Phone')
				.setCondition('Id =: userId')
				.toSOQL()
		);
	}
	/**
	 * @description selectById description
	 *
	 * @param userId (Id): userId
	 * @param profileName (string): profileName
	 * @return Return LIST<User>: Return description
	 */
	public LIST<User> selectById(Id userId, string profileName) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('IsActive')
				.selectField('AB_Number__c')
				.selectField('Email')
				.selectField('SiteCode__c') //Added by Muvhuso
				.selectField('SiteType__c') //Added by Muvhuso
				.selectField('Teller_Operator_Code__c') // Added by Muvhuso
				.selectField('City')
				.selectField('Weather_City__c')
				.selectField('Teller_Operator_Code__c')
				.selectField('MobilePhone')
				.selectField('Phone')
				.selectField('Title') // added by Masechaba Maseli for document generation
				.selectField('LastName')
				.selectField('Supervisor__c') //Lulu by Rankwe
				.selectField('EmployeeNumber')
				.selectField('Address')
				.selectField('Advisor_Code__c')
				.selectField('Profile')
				.selectField('Profile.Name')
				.setCondition('Id =: userId')
				.setCondition('Profile.Name =: profileName')
				.toSOQL()
		);
	}
	/**
	 * @description selectByroleId description
	 *
	 * @param userId (Id): userId
	 * @param roleName (string): roleName
	 * @return Return LIST<User>: Return description
	 */
	public LIST<User> selectByroleId(Id userId, string roleName) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('IsActive')
				.selectField('AB_Number__c')
				.selectField('Email')
				.selectField('SiteCode__c') //Added by Muvhuso
				.selectField('SiteType__c') //Added by Muvhuso
				.selectField('Teller_Operator_Code__c') // Added by Muvhuso
				.selectField('City')
				.selectField('Weather_City__c')
				.selectField('Teller_Operator_Code__c')
				.selectField('MobilePhone')
				.selectField('Title') // added by Masechaba Maseli for document generation
				.selectField('LastName')
				.selectField('Supervisor__c') //Lulu by Rankwe
				.selectField('EmployeeNumber')
				.selectField('Address')
				.selectField('Advisor_Code__c')
				.selectField('Profile')
				.selectField('Profile.Name')
				.selectField('UserRole')
				.selectField('UserRole.Name')
				.setCondition('Id =: userId')
				.setCondition('UserRole.Name =: roleName')
				.toSOQL()
		);
	}
	/**
	 * @description selectByroleId description
	 *
	 * @param roleId (Id): roleId
	 * @return Return List<User>: Return description
	 */
	public List<User> selectByroleId(Id roleId) {
		return Database.query(
			newQueryFactory().selectField('Id').selectField('UserRole').selectField('UserRole.Name').setCondition('UserRole.Id =: roleId').toSOQL()
		);
	}
	/**
	 * @description selectByBridNumber description
	 *
	 * @param bridNumber (String): bridNumber
	 * @param recordLimit (Integer): recordLimit
	 * @return Return List<User>: Return description
	 */
	public List<User> selectByBridNumber(String bridNumber, Integer recordLimit) {
		return Database.query(newQueryFactory().setCondition('BRID__c = :bridNumber').setLimit(recordLimit).toSOQL());
	}

	//User query by BRID Number without a limit
	/**
	 * @description selectByBridNumber description
	 *
	 * @param bridNumber (String): bridNumber
	 * @return Return List<User>: Return description
	 */
	public List<User> selectByBridNumber(String bridNumber) {
		return Database.query(newQueryFactory().setCondition('BRID__c = :bridNumber').toSOQL());
	}

	//User query by BRID Number without a limit
	/**
	 * @description selectByBridNumbers description
	 *
	 * @param bridNumbers (Set<String>): bridNumbers
	 * @return Return List<User>: Return description
	 */
	public List<User> selectByBridNumbers(Set<String> bridNumbers) {
		return Database.query(newQueryFactory().setCondition('BRID__c IN :bridNumbers').toSOQL());
	}
	

	/**
	 * @description Method that gets a list of users from an opportunity owner
	 *
	 * @param oppOwnerId - Set of opportunity Owner ID's
	 * @return list of users with business area
	 */
	public List<User> selectByOpportunityOwnerId(Set<Id> oppOwnerId) {
		return Database.query(newQueryFactory().selectField('Business_Area__c').selectField('Profile.Name').setCondition('Id = :oppOwnerId').toSOQL());
	}

	/**
	 * @description Method that gets a list of users from an opportunity owner
	 *
	 * @param oppOwnerId - opportunity Owner ID's
	 * @return list of users with business area
	 *
	 * Modified by Tinashe Shoko to work for Documents Generation and Uploads USSD Stories
	 * W-003951, W-004228 and W-004229
	 */
	public List<User> selectByOpportunityOwnerId(Id oppOwnerId) {
		return Database.query(
			newQueryFactory()
				.selectField('AB_Number__c')
				.selectField('FirstName')
				.selectField('Phone')
				.selectField('MobilePhone')
				.selectField('Advisor_Code__c')
				.setCondition('Id = :oppOwnerId')
				.toSOQL()
		);
	}

	/** @description Method that gets list of users from AB Number
    * @param  ABNumber
s
    * @return List<User>
    * return list of users
    * @author: Almas Aleem : Absa
    * @created date: 2019-07-17 
    */
	public List<User> selectByAbNumber(String ABNumber) {
		return Database.query(newQueryFactory().selectField('Id').selectField('AB_Number__c').setCondition('AB_Number__c = :ABNumber').toSOQL());
	}

	/** @description Method that gets list of all active users
	 * return list of users
	 * @return List<User>
	 * @author:Diksha Wasekar
	 */
	public List<User> selectactiveusersById() {
		return Database.query(newQueryFactory().selectField('Id').selectField('FirstName').selectField('LastName').setCondition('IsActive=true').toSOQL());
	}

	/** @description Method that gets list of all active users
	 * @param ownerIdVsBodyString
	 * @return List<User>
	 * return list of users
	 * @author:Diksha Wasekar
	 */
	public List<User> selectuserfortask(set<string> ownerIdVsBodyString) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('UserName')
				.selectField('Email')
				.selectField('Name')
				.setCondition('id  IN:ownerIdVsBodyString' + ' AND Profile.Name=\'Standard User (Business Banker)\'')
				.toSOQL()
		);
	}

	/** @description Method that gets list of all active users
	 * @param userEmails
	 * @return List<User>
	 * return list of users
	 * @author:Diksha Wasekar
	 */
	public List<User> selectByEmail(Set<String> userEmails) {
		return Database.query(newQueryFactory().selectField('Id').selectField('Email').setCondition('Email IN :userEmails').toSOQL());
	}

	/** @description Method that gets list of user for complaints sending chatter
	 * @param Employeenumber
	 * @return List<User>
	 * return list of user
	 * @author:Diksha Wasekar
	 */
	public List<User> userwithEmployeeNumber(string Employeenumber) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('EmployeeNumber')
				.selectField('Name')
				.selectField('MobilePhone') // added by muvhuso 23/01/2021
				.selectField('Email') // added by muvhuso 23/01/2021
				.selectField('sitecode__C')
				.selectField('AB_number__c')
				.selectField('Phone')
				.setCondition('employeeNumber =:Employeenumber')
				.toSOQL()
		);
	}

	/** @description Method that gets list of Users based on Id's
	 * @param userIdSet
	 * @return List<User>
	 * return list of users
	 * @author:Diksha Wasekar
	 */
	public List<User> selectByIdWithRole(Set<Id> userIdSet) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('IsActive')
				.selectField('AB_Number__c')
				.selectField('Email')
				.selectField('City')
				.selectField('UserRoleId')
				.selectField('UserRole.Name')
				.selectField('MobilePhone')
				.selectField('LastName')
				.selectField('Name')
				.setCondition('Id IN :userIdSet')
				.toSOQL()
		);
	}

	/** @description Method that gets list of user with sitecodes
	 * @param userId
	 * @return List<User>
	 * return list of users
	 * @author:Haritha
	 */
	public List<User> userwithSiteCode(Id userId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Name')
				.selectField('sitecode__c')
				.selectField('AB_number__c')
				.selectField('Teller_Operator_Code__c')
				.selectField('EmployeeNumber')
				.selectField('Supervisor__c')
				.setCondition('Id =:userId')
				.selectField('SiteType__c')
				.toSOQL()
		);
	}

	/**
	 * @description selectUser description
	 *
	 * @return Return List<User>: Return description
	 */
	public List<User> selectUser() {
		return Database.query(newQueryFactory().selectField('Id').selectField('Name').setCondition('Id =\'' + UserInfo.getUserId() + '\'').toSOQL());
	}

	
	/**
	* @description 
	* @author almas.aleem@absa.africa | 2021-07-12 
	* @param profileName 
	* @return List<User> 
	**/
	public List<User> selectUsersByProfile(String profileName) {
		return Database.query(
			  newQueryFactory().
				   selectField('Id').
				   selectField('Name').
				   setCondition('Profile.Name =\''+profileName+'\'').
				  toSOQL()
	  );
  }
   
	
  /**
  * @description 
  * @author almas.aleem@absa.africa | 2021-07-12 
  * @param profileName 
  * @param Region 
  * @return List<User> 
  **/
  public List<User> selectUsersByProfileandRegion(String profileName,String Region) {
		return Database.query(
			  newQueryFactory().
				   selectField('Id').
				   selectField('Name').
				   setCondition('Profile.Name =\''+profileName+'\' AND RBB_Super_Region__c=\''+ Region+'\'').
				  toSOQL()
	  );
  }  
	/**
	 * @description Returns a User based on a specific User Id
	 *
	 * @param userIds    The SF Id of the User
	 * @return  User    The User object record
	 */
	public List<User> selectByIds(List<Id> userIds) {
		return Database.query(newQueryFactory().selectField('Id').selectField('Name').setCondition('Id IN: userIds').toSOQL());
	}

	/**
	 * @description selectAreaManagers description
	 *
	 * @param siteCodes (Set<String>): siteCodes
	 * @return Return List<User>: Return description
	 */
	public List<User> selectAreaManagers(Set<String> siteCodes) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Name')
				.selectField('sitecode__c')
				.selectField('AB_number__c')
				.selectField('Teller_Operator_Code__c')
				.selectField('EmployeeNumber')
				.setCondition('sitecode__c IN :siteCodes AND UserRole.Name like \'%Area%\'')
				.toSOQL()
		);
	}

	/**
	 * @description selectByIdRefunds description
	 *
	 * @param userId (Id): userId
	 * @return Return User: Return description
	 */
	public User selectByIdRefunds(Id userId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('IsActive')
				.selectField('AB_Number__c')
				.selectField('Email')
				.selectField('SiteCode__c')
				.selectField('Zone__c')
				.selectField('ProfileId')
				.selectField('Title')
				.selectField('DelegatedApproverId')
				.selectField('LastName')
				.setCondition('Id =: userId')
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets users based on adviser Code -Vj
	 *
	 * @param adviserCode
	 * @return users with firstname ,lastname ad required Fileld.
	 *
	 */
	public User selectByAdviserCode(String adviserCode) {
		return Database.query(
			newQueryFactory()
				.selectField('AB_Number__c')
				.selectField('FirstName')
				.selectField('Sanlam_Code__c')
				.selectField('AIMS_Code__c')
				.selectField('Liberty_Code__c')
				.selectField('Momentum_Code__c')
				.selectField('Skills_Products__c')
				.selectField('LastName')
				.selectField('LanguageLocaleKey')
				.selectField('MobilePhone')
				.selectField('Advisor_Code__c')
				.selectField('Email')
				.setCondition('Advisor_Code__c = :adviserCode')
				.setLimit(1)
				.toSOQL()
		);
	}

	/**
	 * @description Method that gets users based on adviser Code -Vj
	 *
	 * @param userId
	 * @return users with id,Email,ManagerId,name,Advisor_code__c .
	 *
	 */
	public User selectUserById(String userId) {
		return Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('Email')
				.selectField('ManagerId')
				.selectField('Name')
				.selectField('Advisor_code__c')
				.setCondition('Id = :userId')
				.toSOQL()
		);
	}

	//CUSTOM SELECTORS - END
	
	//CUSTOM SELECTORS - END
}