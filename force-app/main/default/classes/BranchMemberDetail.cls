/**
 * @description BranchMemberDetail Description
 */
public class BranchMemberDetail{
    @AuraEnabled public String MemberType;
    @AuraEnabled public String PartyId;
    @AuraEnabled public String Name;
    @AuraEnabled public String Surname;
    @AuraEnabled public String Relationship;
    @AuraEnabled public String IDNumber;
    @AuraEnabled public String IdType;
    @AuraEnabled public String Gender;
    @AuraEnabled public Date DateOfBirth;             
    @AuraEnabled public Decimal CoverOption;
    @AuraEnabled public Decimal Premium;
}