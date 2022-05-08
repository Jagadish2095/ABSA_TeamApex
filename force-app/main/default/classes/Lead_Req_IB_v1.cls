/**
 * @description Request Integration Bean for Lead Service for Absa Instant Life
 * @author Satya Boyenepalli
 * @created 2021-07-28
 */
public with sharing class Lead_Req_IB_v1 extends Base_IB {
	/**
	 * @description Address1
	 */
	public String Address1;
	/**
	 * @description Address2
	 */
	public String Address2;
	/**
	 * @description Address3
	 */
	public String Address3;
	/**
	 * @description AltPhone
	 */
	public String AltPhone;
	/**
	 * @description CampaignId
	 */
	public String CampaignId;

	/**
	 * @description City
	 */

	public String City;
	/**
	 * @description Comments
	 */
	public String Comments;
	/**
	 * @description DateOfBirth
	 */
	public String DateOfBirth;
	/**
	 * @description Email
	 */
	public String Email;
	/**
	 * @description FirstName
	 */
	public String FirstName;
	/**
	 * @description Gender
	 */
	public String Gender;
	/**
	 * @description SouthAfricanId
	 */
	public String SouthAfricanId;
	/**
	 * @description LastName
	 */
	public String LastName;
	/**
	 * @description MiddleInitial
	 */
	public String MiddleInitial;
	/**
	 * @description PartyId
	 */
	public String PartyId;
	/**
	 * @description Password
	 */
	public String Password;
	/**
	 * @description PhoneNumber
	 */
	public String PhoneNumber;
	/**
	 * @description PostalCode
	 */
	public String PostalCode;
	/**
	 * @description Province
	 */
	public String Province;
	/**
	 * @description Title
	 */
	public String Title;
	/**
	 * @description UserName
	 */
	public String UserName;
	/**
	 * @description CallbackDateTime
	 */
	public String CallbackDateTime;

	/**
	 * @description dummy req for Quote
	 * @author  Satya Boyenepalli
	 * @since 2021-07-28
	 * @return Quote_Req_IB_v1
	 */
	public static Lead_Req_IB_v1 createDummyRequest() {
		Lead_Req_IB_v1 requestBean = new Lead_Req_IB_v1();
		requestBean.Address1 = '100 Complex, 10 Street Address';
		requestBean.Address2 = 'Surburb';
		requestBean.Address3 = 'City';
		requestBean.AltPhone = 'tyuiop';
		requestBean.CampaignId = '8474-EXSB149';
		requestBean.City = 'City';
		requestBean.Comments = 'tyuiop';
		requestBean.DateOfBirth = '1996-07-18';
		requestBean.Email = 'person@gmail.com';
		requestBean.FirstName = 'Name';
		requestBean.Gender = 'M';
		requestBean.SouthAfricanId = '9607189556080';
		requestBean.LastName = 'Surname';
		requestBean.MiddleInitial = 'M';
		requestBean.PartyId = '133963';
		requestBean.Password = 'FredSmith1';
		requestBean.PhoneNumber = '0726631180';
		requestBean.PostalCode = '2194';
		requestBean.Province = 'Gauteng';
		requestBean.Title = 'Mr';
		requestBean.UserName = 'leo@intellimin.com';
		requestBean.CallbackDateTime = '2021-08-31T14:00:00';

		return requestBean;
	}
}