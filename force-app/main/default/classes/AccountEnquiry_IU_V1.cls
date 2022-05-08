/**
 * @description       : AccountEnquiry_IU_V1
 * @author            : Mradul Maheshwari
 * @last modified on  : 28-09-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : W-013340
 **/
public with sharing class AccountEnquiry_IU_V1 {
  /**
   * @description mapRequestFields
   * @author Mradul Maheshwari | 14-09-2021
   * @param accountNumber
   * @param abNumber
   * @return AccountEnquiry_Req_IB_V1
   **/
  public static AccountEnquiry_Req_IB_V1 mapRequestFields(
    String accountNumber,
    String abNumber
  ) {
    AccountEnquiry_Req_IB_V1 requestBean = new AccountEnquiry_Req_IB_V1();

    AccountEnquiry_Req_IB_V1.NBSAPDPI NBSAPDPI = new AccountEnquiry_Req_IB_V1.NBSAPDPI();

    AccountEnquiry_Req_IB_V1.NBSAPLI NBSAPLI = new AccountEnquiry_Req_IB_V1.NBSAPLI();
    NBSAPLI.NBNAPLI_CHANNEL = 'API';
    NBSAPLI.NBNAPLI_APPLICATION = 'Gateway';
    NBSAPLI.NBNAPLI_TRACE = '';

    NBSAPDPI.NBSAPLI = NBSAPLI;
    requestBean.NBSAPDPI = NBSAPDPI;

    AccountEnquiry_Req_IB_V1.NBSMSGI_Z NBSMSGI_var = new AccountEnquiry_Req_IB_V1.NBSMSGI_Z();
    AccountEnquiry_Req_IB_V1.NBSMSGI NBSMSGI = new AccountEnquiry_Req_IB_V1.NBSMSGI();
    NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
    NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';

    NBSMSGI_var.NBSMSGI = NBSMSGI;
    requestBean.NBSMSGI = NBSMSGI_var;

    AccountEnquiry_Req_IB_V1.MLB857I MLB857I = new AccountEnquiry_Req_IB_V1.MLB857I();
    AccountEnquiry_Req_IB_V1.MLB857I_INPUT_AREA MLB857I_INPUT_AREA = new AccountEnquiry_Req_IB_V1.MLB857I_INPUT_AREA();
    MLB857I_INPUT_AREA.MLB857I_ACCT_NUMBER = Long.valueOf(accountNumber);
    MLB857I_INPUT_AREA.MLB857I_USER_ID = abNumber;
    MLB857I_INPUT_AREA.MLB857I_SITE_CODE = 'CUSTOMR1';

    MLB857I.MLB857I_INPUT_AREA = MLB857I_INPUT_AREA;
    requestBean.MLB857I = MLB857I;

    return requestBean;
  }
}