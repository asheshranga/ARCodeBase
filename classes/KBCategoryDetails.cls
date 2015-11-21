// wrapper class for the article category
public with sharing class KBCategoryDetails {
    public string Name { get; set; }
    public string Label { get; set; }
    
    public KBCategoryDetails(string nm, string lb) {
        Name = nm;
        Label = lb;
    }
}