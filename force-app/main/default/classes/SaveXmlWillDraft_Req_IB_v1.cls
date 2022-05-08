public class SaveXmlWillDraft_Req_IB_v1 extends Base_IB
{	
	public String key;
	public String value;
	
	public SaveXmlWillDraft_Req_IB_v1() {}
	
	public SaveXmlWillDraft_Req_IB_v1(String key, String value) {
		this.key = key;
		this.value = value;
	}
	
   	public List<SaveXmlWillDraft_Req_IB_v1> createDummyRequest()
    {              	
        SaveXmlWillDraft_Req_IB_v1 draft1 = new SaveXmlWillDraft_Req_IB_v1();
        draft1.key = 'willNo';
        draft1.value = '41005576899';
        
        SaveXmlWillDraft_Req_IB_v1 draft2 = new SaveXmlWillDraft_Req_IB_v1();
        draft2.key = 'createdDate';
        draft2.value = '2019-01-19 12:00:00';
        
        SaveXmlWillDraft_Req_IB_v1 draft3 = new SaveXmlWillDraft_Req_IB_v1();
        draft3.key = 'modifiedDate';
        draft3.value = '2019-02-19 13:10:00';
        
        SaveXmlWillDraft_Req_IB_v1 draft4 = new SaveXmlWillDraft_Req_IB_v1();
        draft4.key = 'xmlData';
        draft4.value = '<?xml version="1.0" encoding="Windows-1252" standalone="yes"?> <AnswerSet title="Blank Answer file" version="1.1"> <Answer name="(ANSWER FILE HISTORY)"> <TextValue>Absa WIMI Wills Solution : February 4, 2019, 9:32</TextValue> </Answer> <Answer name="Address_Terms-t"> <RptValue> <TextValue>residential address</TextValue> </RptValue> </Answer> <Answer name="PRC_PartyCitationHeading-t"> <RptValue> <TextValue>Identity number</TextValue> </RptValue> </Answer> <Answer name="PRC_PartyCountry-t"> <RptValue> <TextValue>South Africa</TextValue> </RptValue> </Answer> <Answer name="PRC_PartyCountryText-t"> <RptValue> <TextValue/> </RptValue> </Answer> <Answer name="PRC_PartyFullName-t"> <RptValue> <TextValue>[INSERT PARTY FULL NAME]</TextValue> </RptValue> </Answer> <Answer name="PRC_PartyFullNameRequirementsText-t"> <RptValue> <TextValue>«.i»(Insert full names, e.g "John Alexander Smith")«.ie»</TextValue> </RptValue> </Answer> <Answer name="PRC_PartyFullNameResult-t"> <RptValue> <TextValue>[INSERT FULL NAME]</TextValue> </RptValue> </Answer> <Answer name="PRC_PartyHeaderFullName-t"> <RptValue> <TextValue>«.B»[INSERT FULL NAME]«.BE»</TextValue> </RptValue> </Answer> <Answer name="PRC_PartyNumberDescription-t"> <RptValue> <TextValue>Identity number</TextValue> </RptValue> </Answer> <Answer name="PRC_PartyRegistration/IdentityNo-t"> <RptValue> <TextValue>[INSERT NUMBER]</TextValue> </RptValue> </Answer> <Answer name="PRC_PartyRegistrationNoInternationalPrompt-t"> <RptValue> <TextValue>identification</TextValue> </RptValue> </Answer> <Answer name="PRC_PartyRegistrationNoSouthAfricanText-t"> <RptValue> <TextValue/> </RptValue> </Answer> <Answer name="PRC_PartyRepresentativeIncTitle-t"> <RptValue> <TextValue>«.b»[Insert Representative Name]«.be»</TextValue> </RptValue> </Answer> <Answer name="PRC_PartyRepresentativeMiddleName-t"> <RptValue> <TextValue/> </RptValue> </Answer> <Answer name="PRC_PartyRepresentativeNameSuffix-t"> <RptValue> <TextValue/> </RptValue> </Answer> <Answer name="PRC_Party_Citation_Address-t"> <RptValue> <TextValue>[INSERT PHYSICAL ADDRESS]</TextValue> </RptValue> </Answer> <Answer name="PRC_Party_Citation_Address_Name-t"> <RptValue> <TextValue>physical address</TextValue> </RptValue> </Answer> <Answer name="PRC_Party_REGISTRATION_IDENTITY_Text-t"> <RptValue> <TextValue>[INSERT IDENTITY NUMBER]</TextValue> </RptValue> </Answer> <Answer name="PRC_Party_Registration_Identity_Text-t"> <RptValue> <TextValue>Identity</TextValue> </RptValue> </Answer> <Answer name="Child_Number-n"> <NumValue>0.0000000</NumValue> </Answer> <Answer name="PRC_PartyContactDetailsRequired-n"> <RptValue> <NumValue>0.0000000</NumValue> </RptValue> </Answer> <Answer name="PRC_PartyDivisionDeterminator-n"> <RptValue> <NumValue>0.0000000</NumValue> </RptValue> </Answer> <Answer name="PRC_PartySouthAfricanDeterminator-n"> <RptValue> <NumValue>1.0000000</NumValue> </RptValue> </Answer> <Answer name="PRC_PartyTradingAsDeterminator-n"> <RptValue> <NumValue>0.0000000</NumValue> </RptValue> </Answer> <Answer name="Trust_Counter-n"> <RptValue> <NumValue>0.0000000</NumValue> </RptValue> </Answer> <Answer name="Use_Physical1_Or_Registered2_In_Citation-n"> <RptValue> <NumValue>1.0000000</NumValue> </RptValue> </Answer> <Answer name="Beneficiary_Trust-tf"> <RptValue> <TFValue>false</TFValue> </RptValue> </Answer> <Answer name="Children_Entire_Estate-tf"> <RptValue> <TFValue>false</TFValue> </RptValue> </Answer> <Answer name="Children_Entire_Estate1-tf"> <RptValue> <TFValue>false</TFValue> </RptValue> </Answer> <Answer name="Children_Entire_Estate2-tf"> <RptValue> <TFValue>false</TFValue> </RptValue> </Answer> <Answer name="Executor_Deduction-tf"> <TFValue>false</TFValue> </Answer> <Answer name="Executor_Fee_Seperate-tf"> <TFValue>false</TFValue> </Answer> <Answer name="Executor_Security-tf"> <TFValue>false</TFValue> </Answer> <Answer name="Family_Obliteration-tf"> <TFValue>false</TFValue> </Answer> <Answer name="Guardian_Provision-tf"> <TFValue>false</TFValue> </Answer> <Answer name="Guardian_Safekeeping-tf"> <TFValue>false</TFValue> </Answer> <Answer name="Inter_Vivos_Trust-tf"> <RptValue> <TFValue>false</TFValue> </RptValue> </Answer> <Answer name="Inter_Vivos_Trust1-tf"> <RptValue> <TFValue>false</TFValue> </RptValue> </Answer> <Answer name="PRC_IncludeEmail-tf"> <RptValue> <TFValue>false</TFValue> </RptValue> </Answer> <Answer name="PRC_IncludeFax-tf"> <RptValue> <TFValue>false</TFValue> </RptValue> </Answer> <Answer name="PRC_IncludePhysicalAddress-tf"> <RptValue> <TFValue>false</TFValue> </RptValue> </Answer> <Answer name="PRC_IncludePostalAddress-tf"> <RptValue> <TFValue>false</TFValue> </RptValue> </Answer> <Answer name="PRC_PartyActingThroughDivision-tf"> <RptValue> <TFValue>false</TFValue> </RptValue> </Answer> <Answer name="PRC_PartyIndividual-tf"> <RptValue> <TFValue>true</TFValue> </RptValue> </Answer> <Answer name="PRC_PartyTradingAs-tf"> <RptValue> <TFValue>false</TFValue> </RptValue> </Answer> <Answer name="Policy_Proceeds-tf"> <TFValue>false</TFValue> </Answer> <Answer name="Potential_Insolvency-tf"> <TFValue>false</TFValue> </Answer> <Answer name="Residue_By_List-tf"> <TFValue>false</TFValue> </Answer> <Answer name="Specific_Condition_Trust-tf"> <TFValue>false</TFValue> </Answer> <Answer name="Survivor2_Special_Conditions-tf"> <RptValue> <TFValue>false</TFValue> </RptValue> </Answer> <Answer name="Survivor_Youngest_Trust-tf"> <RptValue> <TFValue>false</TFValue> </RptValue> </Answer> <Answer name="Executor-mc"> <MCValue> <SelValue>Absa Trust (Sole Executor)</SelValue> </MCValue> </Answer> <Answer name="PRC_PartyEntityType-mc"> <RptValue> <MCValue> <SelValue>South African - Individual</SelValue> </MCValue> </RptValue> </Answer> <Answer name="PRC_PartyRegType-mc"> <RptValue> <MCValue> <SelValue>SA Identity Number</SelValue> </MCValue> </RptValue> </Answer> <Answer name="Text_Size-mc"> <MCValue> <SelValue>Normal (10pt)</SelValue> </MCValue> </Answer> </AnswerSet>';
        
    	List<SaveXmlWillDraft_Req_IB_v1> reqBean = new List<SaveXmlWillDraft_Req_IB_v1>();
    	reqBean.add(draft1);
    	reqBean.add(draft2);
    	reqBean.add(draft3);
    	reqBean.add(draft4);
                       
        System.debug('RequestBean: ' + reqBean);        
        return reqBean;    
    }
    
}