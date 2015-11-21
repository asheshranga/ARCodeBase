public class WispUnderConstructionController {
    public string underConstruction1{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_UnderConstruction_msg1);}set;}
    public string underConstruction2{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_UnderConstruction_msg2);}set;}
    public string copyRight{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_copyright);}set;}
    public string privacyPolicy{get{return AtlasUtility.getMapWispValue(Atlasconstants.Wisp_PrivacyPolicy);}set;}
    
    public WispUnderConstructionController() {}
}