/**
 * @description BranchMemberDetail Description
 */
public class BranchPolicyDetails{
	@AuraEnabled
	public string Policy;
	@AuraEnabled
	public Double CalculatedPremium;
	@AuraEnabled
	public Double CurrentCoverOption;
	@AuraEnabled
	public String ProductCode;
	@AuraEnabled
	public String MemberId;
	@AuraEnabled
	public List<BranchMemberDetail> MainMember;
	@AuraEnabled
	public List<BranchMemberDetail> AdditionalMembers;
	@AuraEnabled
	public List<BranchMemberDetail> Beneficiaries;
	@AuraEnabled
	public WBIF_Product_Details ProductDetails;

}