/**
* @description Integration Utility class for the ContractAddComponent
*
* @author  Koketso Mpshane
* @created 2021-08-16
*/
public class ContractAddComponent_IU_v1 {
    /**
	* @description mapRequestFields
	* @param memberDetails
	* @return ContractAddComponent_Req_IB_v1
	*/
    public static ContractAddComponent_Req_IB_v1 mapRequestFields(Map<String, String> memberDetails){
        ContractAddComponent_Req_IB_v1 requestBean = new ContractAddComponent_Req_IB_v1();
        requestBean.Contract_Add_Component = new ContractAddComponent_Req_IB_v1.Contract_Add_Component();
        requestBean.Contract_Add_Component.Request = new ContractAddComponent_Req_IB_v1.Request();
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request = new ContractAddComponent_Req_IB_v1.MemberAdd_Capture_Request();
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Dependent = new ContractAddComponent_Req_IB_v1.Dependent();
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Dependent.DependentInformantAddress = new ContractAddComponent_Req_IB_v1.DependentInformantAddress();
        
        requestBean.Contract_Add_Component.pstrSessionGID = ExergyLoginController.getSessionId();
        requestBean.Contract_Add_Component.pstrContractGID = memberDetails.get('contractGID');
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.ClientGID = memberDetails.get('clientGID');
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Cover = Integer.valueOf(memberDetails.get('cover'));
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Dependent.Cellphone = memberDetails.get('cellphone');
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Dependent.DateOfBirth = memberDetails.get('dateOfBirth');
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Dependent.DependentInformantAddress.AddressLine1 = memberDetails.get('addressLine1');
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Dependent.DependentInformantAddress.AddressLine2 = memberDetails.get('addressLine2');
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Dependent.DependentInformantAddress.AddressTypeID = Integer.valueOf(memberDetails.get('addressTypeID'));
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Dependent.DependentInformantAddress.CountryID = memberDetails.get('countryID');
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Dependent.DependentInformantAddress.PostalCode = memberDetails.get('postalCode');
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Dependent.EmailAddress = memberDetails.get('emailAddress');
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Dependent.FirstName = memberDetails.get('firstName');
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Dependent.GenderID = Integer.valueOf(memberDetails.get('genderID'));
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Dependent.IDDescription = memberDetails.get('idDescription');
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Dependent.IDTypeID = Integer.valueOf(memberDetails.get('idTypeID'));
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Dependent.Surname = memberDetails.get('surname');
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.Dependent.TitleID = Integer.valueOf(memberDetails.get('titleID'));
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.ProductID = Integer.valueOf(memberDetails.get('productID'));
        requestBean.Contract_Add_Component.Request.MemberAdd_Capture_Request.RelationshipToMainMember = Integer.valueOf(memberDetails.get('relationshipToMainMember'));
        
        return requestBean;
    }

}