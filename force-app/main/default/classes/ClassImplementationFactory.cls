/**
 * @description       : Get Class Implementation based on Interface.
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-13
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
public class ClassImplementationFactory {
	/**
	 * @description
	 * @author PaulJohn.duRand@absa.africa | 2021-08-02
	 * @param classType
	 * @param objId
	 * @return object
	 **/
	public static object getClassImplementation(string classType, String objId) {
		string implementationClass;
		string accountId = BranchFunctions.getAccountId(objId);
		string accountType = 'PersonAccount';
		if (BranchFunctions.isBusinessProspect(accountId)) {
			accountType = 'BusinessAccount';
		}
		List<ClassImplementation__mdt> test = [SELECT DeveloperName FROM ClassImplementation__mdt WHERE Type__c = :classType AND AccountType__c = :accountType];
        implementationClass = test[0].DeveloperName;
		Type ImplementationClassType = Type.forName(implementationClass);
		return ImplementationClassType.newInstance();
	}

    /**
    * @description
    * @author PaulJohn.duRand@absa.africa | 2021-08-02
    * @param stringRef
    * @return object
    **/
    public static object getClassImplementationByStringRef(string stringRef) {
        string implementationClass;
		List<ClassImplementation__mdt> test = [SELECT DeveloperName FROM ClassImplementation__mdt WHERE TextRef__c = :stringRef];
        implementationClass = test[0].DeveloperName;
		Type ImplementationClassType = Type.forName(implementationClass);
		return ImplementationClassType.newInstance();
	}
}