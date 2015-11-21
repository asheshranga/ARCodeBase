/*********************************************************************************
Name         : AtlasSSOWSMock 
Created By   : Shiva Shankar
Modified BY  : Shiva Shankar
Company Name : NTT Data
Project      : ViaSat Atlas, Bangalore
Created Date : 
Modified Date: 18 June 2014
Usages       : Atlas Webservice Testing Framwork called from : AtlasSSOTestClass
*********************************************************************************/
@isTest
global class AtlasSSOWSMock implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request, 
       		Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) 
           {
           		if(requestName.contains('resetPassword'))
                {
                    AtlasSSOWS.resetPasswordResponse_element c=(AtlasSSOWS.resetPasswordResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('resetPasswordResponse'),AtlasSSOWS.resetPasswordResponse_element.class);
                    AtlasSSOWS.resetPasswordResponse_element respElement = new AtlasSSOWS.resetPasswordResponse_element();
                    response.put('response_x', c);
                }
                if(requestName.contains('changePassword'))
                {
                    AtlasSSOWS.changePasswordResponse_element c=(AtlasSSOWS.changePasswordResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('changePwdResponse'),AtlasSSOWS.changePasswordResponse_element.class);
                    AtlasSSOWS.changePasswordResponse_element respElement = new AtlasSSOWS.changePasswordResponse_element();
                    response.put('response_x', c);
                }
                if(requestName.contains('getSubscribers'))
                {
                    AtlasSSOWS.getSubscribersResponse_element c=(AtlasSSOWS.getSubscribersResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('findSSOSubscribersResponse'),AtlasSSOWS.getSubscribersResponse_element.class);
                    AtlasSSOWS.getSubscribersResponse_element respElement = new AtlasSSOWS.getSubscribersResponse_element();
                    response.put('response_x', c);
                }
                if(requestName.equalsignorecase('getSubscriber'))
                {
                    AtlasSSOWS.getSubscriberResponse_element c=(AtlasSSOWS.getSubscriberResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('findSSOSubscriberResponse'),AtlasSSOWS.getSubscriberResponse_element.class);
                    AtlasSSOWS.getSubscriberResponse_element respElement = new AtlasSSOWS.getSubscriberResponse_element();
                    response.put('response_x', c);
                }
                if(requestName.equalsignorecase('login'))
                {
                    AtlasSSOWS.loginResponse_element c=(AtlasSSOWS.loginResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('loginResponse'),AtlasSSOWS.loginResponse_element.class);
                    AtlasSSOWS.loginResponse_element respElement = new AtlasSSOWS.loginResponse_element();
                    response.put('response_x', c);
                }
                if(requestName.equalsignorecase('uploadFile'))
                {
                    AtlasSSOWS.uploadFileResponse_element c=(AtlasSSOWS.uploadFileResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('fileUploadResponse'),AtlasSSOWS.uploadFileResponse_element.class);
                    AtlasSSOWS.uploadFileResponse_element respElement = new AtlasSSOWS.uploadFileResponse_element();
                    response.put('response_x', c);
                }
                if(requestName.equalsignorecase('changeLoginUserName'))
                {
                    AtlasSSOWS.changeLoginUserNameResponse_element c=(AtlasSSOWS.changeLoginUserNameResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('changeUserNameResponse'),AtlasSSOWS.changeLoginUserNameResponse_element.class);
                    AtlasSSOWS.changeLoginUserNameResponse_element respElement = new AtlasSSOWS.changeLoginUserNameResponse_element();
                    response.put('response_x', c);
                }
                if(requestName.equalsignorecase('saveSecurityQuestions'))
                {
                    AtlasSSOWS.saveSecurityQuestionsResponse_element c=(AtlasSSOWS.saveSecurityQuestionsResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('saveSQResponse'),AtlasSSOWS.saveSecurityQuestionsResponse_element.class);
                    AtlasSSOWS.saveSecurityQuestionsResponse_element respElement = new AtlasSSOWS.saveSecurityQuestionsResponse_element();
                    response.put('response_x', c);
                }
                if(requestName.equalsignorecase('updateSubscriber'))
                {
                    AtlasSSOWS.updateSubscriberResponse_element c=(AtlasSSOWS.updateSubscriberResponse_element)JSON.deserialize(AtlasTestConstants.getMetadata('updateSubscriberResponse'),AtlasSSOWS.updateSubscriberResponse_element.class);
                    AtlasSSOWS.updateSubscriberResponse_element respElement = new AtlasSSOWS.updateSubscriberResponse_element();
                    response.put('response_x', c);
                }
		   }
}