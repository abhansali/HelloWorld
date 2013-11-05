public with sharing class EEREReviewController implements EEREIRecordViewer{
    
    //Meeting Variables
     public List<MeetingHandler> meetingHandlers {get; set;}
    public MeetingHandler selectedMeeting {get;set;}
    public Boolean newM {get; private set;}
        public EERE_Meeting__c currentMeeting {get; set;}
            public String meetingId {get;set;}
                public ID selectedMeetingId {get; set;}
                    public Boolean isMeetingSuccess {get; private set;}
                    
     //Finding VariablesupdateStatus
     // public List<FindingHandler> findingHandlers {get; set;}
     // public FindingHandler selectedFinding {get;set;}
      
      
      //NEW FINDING VARIABLES
      public list<EERE_Finding__c> findingList {get; set;}
      public EERE_Finding__c selectedFinding {get;set;}
      public ID selectedRecordId {get; set;}
      public EERE_Finding__c newFinding {get;set;}
      public Boolean isEditMode {get;set;}
      
                

    public String strDocUrl { get; set; }
        public String reviewTitle { get; set; }
    
    public ID projectId {get; private set;}
    public ID selectedReviewId {get; set;}
    public PageReference thisPage {get; private set;}
    public ReviewWrapper newReview {get; set;}
    public EERE_Review__c currentReview {get; set;}
    public String currentTab {get;set;}
     
    public Boolean editMode {get; private set;}
    public Boolean editSuccess {get; private set;}
    
    public Boolean isRecords {get; private set;}
    public Boolean isSuccess {get; private set;}
    public Boolean isPortalUser {get; private set;}
    
    
    public Boolean isFinding {get; private set;}
    public Boolean createNewReview {get; private set;}
    
    public String referer {get; set;}
    
    /** Wrapper Variables**/
    public List<ReviewWrapper> reviews {get; private set;}
    public Boolean showContentDialog {get; set;}
    public String reviewId {get;set;}
    
    /*Wrapper Content Variables*/
    public List<EEREContentItem> contentList {get; private set;}
    public EERE_Review__c review {get; private set;}
    public Boolean hasContent {get; private set;}
    private EEREReviewController reviewController;
    public boolean editing{get;set;}
    public String currentUserID {get;set;}
    public Boolean isTM {get; private set;}
    public Boolean isPMCO {get; private set;}
    public Boolean isExec {get; private set;}
    
    public EERE_Team_Member__c projectTM {get;set;}
    public Boolean currentUserTM {get; private set;}



    public EEREReviewController() {
        projectId = Apexpages.currentPage().getParameters().get('id');
        currentTab = Apexpages.currentPage().getParameters().get('currentTab');
        selectedReviewId = Apexpages.currentPage().getParameters().get('reviewID');
        selectedMeetingId = Apexpages.currentPage().getParameters().get('meetingID');
        isPortalUser = EERESOQLUtils.isPortalUser();
        currentUserID = UserInfo.getUserId();
        
        if(!isPortalUser){
            isPMCO = EERESOQLUtils.isPMCO();
            isExec = EERESOQLUtils.isExecutive();
        }
        else{
            isPMCO = false;
            isExec = false;
        }
        
        newReview = new ReviewWrapper(this);
   
        thisPage = ApexPages.currentPage();
     
        editMode = false;
        isRecords = false;
        isFinding = false;
        createNewReview = true;
        editSuccess = false;
        currentUserTM = false;
        newM = false;
        isTM = false;
        isEditMode = false;
        
        initialize();
        isMeetingSuccess = false;
        
        
        updateReferer();
        //initializeFinding();
    }
    
    public void setCurrentTab(string t){
        currentTab = t; 
    }
    
    public void updateReferer(){
        if (thisPage!=null){
            referer = thisPage.getUrl();
            
            if (currentTab!=''){
                referer = referer + '&currentTab=' + currentTab;
            }
        }
    }
    
    public boolean hasContent(){
        return !contentList.isEmpty();
    }
    
  public void updateMeetingReferer(){
        if (thisPage!=null){
            referer = thisPage.getUrl();
        }}
  
    public void initialize() 
    {
       
        list<EERE_Team_Member__c> projectTMList = new list<EERE_Team_Member__c>();
        projectTMList = [SELECT Id, Name, Role__c, 
        Team_Member__c FROM EERE_Team_Member__c WHERE Project__c = :projectId AND Role__c = 'Technology Manager' LIMIT 1];
        if(projectTMList!=null &&projectTMList.size() > 0){
        projectTM = projectTMList[0];
        }
        
        if(currentUserID==projectTM.Team_Member__c){
            currentUserTM = true;
        }
        else{
        currentUserTM = false;
        }
        
        meetingInit();
        

        if(selectedReviewId!=null) {
           currentReview = [SELECT Name, OwnerID, Owner.Name, RecordTypeID, Review_Type__c, APM_Review_Status__c, CreatedDate, Purpose__c, Scope_Description__c, Scheduled_Visit_Date__c, EERE_Site_Visitor_New__c, Performers_Interviewed_New__c,
                    Worksites_Visited__c, APM_Completion_Date__c,
                    Progress_Review_Due_Date__c, Progress_Review_Completed_Date__c, 
                    Project_Progress_Scope__c, Scope_Contributing_Factors__c, Cost_Deviated_Ten_Percent__c, Schedule_Deviation_Ten_Percent__c,
                    Severity_of_Budget_Deviation__c, 
                    Severity_of_Schedule_Deviation__c, Budget_Contributing_Factors__c, Schedule_Contributing_Factors__c, Adequate_Corrective_Action_Plan_progress__c, PPD_Updates__c, High_Priority_Project__c,
                    Progress_Review_Comments__c, Progress_Review_Status__c,
                    Report_Due_Date__c, Review_Scope__c, Related_Project__c, Meet_Goals_Objectives__c, Scope_Issues__c, 
                    Recommendations__c, IPR_Review_Status__c, IPR_Best_Practices__c,
                    Schedule_Issues__c, Internal_Comments__c, Performer_Comments__c,
                    NEPA_Compliance__c, 
                    NEPA_Requirements_Progress__c, Financial_Narrative__c,
                    Davis_Bacon_Compliance__c, Technology_Commercializing__c, 
                    Budget_Issues_Contributing_Factors__c, 
                    Technical_Progress__c, General_Administration_Progress__c, Personnel_Issues_Progress__c, Technical_Administration_Narrative__c,
                    Milestone_Schedule_Progress__c, Budget_Issues__c, Departmental_Resources__c, Sub_Performer_Monitoring__c, Project_Renovations__c, EERE_Site_Visitor__c, Performers_Interviewed__c,
                    Budget_Developments__c, Procurement_Developments__c, Payroll_Developments__c, Equipment_Developments__c, Sub_Contract_Developments__c, Financial_Management_Developments__c,
                    Record_Developments__c, Performer_Dicussions__c, Best_Practices__c, Orientation_Meeting_Completed_Date__c, APM_Review_Comments__c, Actual_Site_Visit_Date__c,
                    Orientation_Meeting_Location__c, Orientation_Meeting_Notes__c, Orientation_Scheduled_Meeting_Date__c, Attendees__c, Invitees__c, Follow_Up_Meeting_Date__c, CAP_Related__c, CAP_Progress__c, CAP_Adequate_Actions__c,
                    Project_Management_Plan_Exists__c, Project_Management_Plan_Is_Current__c, Scope_Exists__c, Scope_Is_Current__c, Scope_Issues_or_Inconsistencies_Observed__c, 
                    Scope_Performance_Tracked_Exists__c, 
                    Scope_Performance_Tracked_Is_Current__c, 
                    Scope_Links_to_Budget_Exists__c, 
                    Scope_Links_to_Budget_Is_Current__c, 
                    Scope_Links_to_Schedule_Exists__c, Scope_Links_to_Schedule_Is_Current__c,
                    
                    Schedule_Performance_Tracked_Exists__c, Schedule_Performance_Tracked_Is_Current__c, 
                    
                    Schedule_Links_to_Budget_Exists__c, Schedule_Links_to_Budget_Is_Current__c, Budget_Detail_Exists__c,
                    Budget_Detail_Is_Current__c, Budget_Performance_Tracked_Exists__c, Budget_Performance_Tracked_Is_Current__c, 
                    
                    Programmatic_Risks_Exist__c, Programmatic_Risks_Are_Current__c,
                    
                    Project_Risks_Exist__c, Project_Risks_Are_Current__c, Project_Risk_Mitigation_Strategy_Exists__c, Research_Project_Progress_Reports_Exist__c, 
                    
                    Lessons_Learned__c, Overall_Performance_Observations__c, Scope_Observations__c, Schedule_Observations__c, Budget_Observations__c, 
                    Risk_Observations__c, Recommendation_Observations__c, Actions_for_the_Project_Lead_Observation__c,
                    IPR_Start_Date__c, IPR_End_Date__c, IPR_Review_Team__c, IPR_Requestor__c, IPR_Outcomes__c, IPR_Number__c, 
                    Scope_of_Project__c,
                    PMP_Issues_Inconsistencies_Observed__c,
                    Scope_Perf_Demonstrates_Proj_On_Track__c, Scope_Perf_Tracked_Issues_Observed__c, 
                    Scope_Links_to_Budget_Issues_Observed__c, Scope_Links_to_Sched_Issues_Observed__c, 
                    Project_Schedule_Exists__c, Project_Schedule_Is_Current__c, Project_Schedule_Issues_Observed__c, 
                    
                    
                    Sched_Perf_Demonstrates_Proj_On_Track__c, Sched_Perf_Tracked_Issues_Observed__c, 
                    
                    Sched_Links_to_Budget_Issues_Observed__c, 
                 Budget_Detail_Identified_Issues_Observed__c, 
                    Budget_Perf_Demonstrates_Proj_On_Track__c, Budget_Perf_Tracked_Issues_Observed__c, 
                    
                    Programmatic_Risks_or_Issues_Observed__c, 
                    Programmatic_Risk_MT_Strategy_Exists__c, Programmatic_Risk_MT_Strategy_is_Current__c, Prog_Risk_MT_Strat_Issues_Observed__c, 
                    
                    Project_Risks_Issues_Observed__c, 
                    Project_Risk_MT_Strategy_Is_Current__c, Proj_Risk_MT_Strategy_Issues_Observed__c, 
                    Research_Proj_Prog_Reports_Are_Current__c, 
                    Res_Prog_Reports_Demo_Proj_On_Track__c, Res_Proj_Prog_Report_Issues_Observed__c, 
                    Progress_Review_Exists__c, Progress_Review_is_Current__c, Progress_Review_Issues_Observed__c, 
                    Active_Proj_Mgmt_Visit_Report_Exists__c, Active_Proj_Mgmt_Visit_Report_Current__c, Active_Proj_Mgmt_Visit_Report_On_Track__c, Active_Proj_Mgmt_Visit_Report_Iss_Obs__c, 
                    Research_Proj_Prog_Reports_Observations__c, Progress_Review_Observations__c, Review_Locked__c
                    FROM EERE_Review__c
                    WHERE ID = :selectedReviewID];
                 System.debug('hello selected review' + currentReview.id);
                 reviewTitle = currentReview.Name;
                 loadContent();
        } 
        
       else {
        if(isPortalUser){
        showContentDialog = false;
            reviews = new List<ReviewWrapper>();
            for (EERE_Review__c r : [SELECT Name, OwnerID, RecordTypeID, Review_Type__c, APM_Review_Status__c, CreatedDate, Purpose__c, Scope_Description__c, Scheduled_Visit_Date__c, EERE_Site_Visitor_New__c, Performers_Interviewed_New__c,
                    Worksites_Visited__c, APM_Completion_Date__c,
                    Progress_Review_Due_Date__c, Progress_Review_Completed_Date__c, 
                    Project_Progress_Scope__c, Scope_Contributing_Factors__c, Cost_Deviated_Ten_Percent__c, Schedule_Deviation_Ten_Percent__c,
                    Severity_of_Budget_Deviation__c, 
                    Severity_of_Schedule_Deviation__c, Budget_Contributing_Factors__c, Schedule_Contributing_Factors__c, Adequate_Corrective_Action_Plan_progress__c, PPD_Updates__c, High_Priority_Project__c,
                    Progress_Review_Comments__c, Progress_Review_Status__c,
                    Report_Due_Date__c, Review_Scope__c, Related_Project__c, Meet_Goals_Objectives__c, Scope_Issues__c, 
                    Recommendations__c, IPR_Review_Status__c, IPR_Best_Practices__c,
                    Schedule_Issues__c, Internal_Comments__c, Performer_Comments__c,
                    NEPA_Compliance__c, 
                    NEPA_Requirements_Progress__c, Financial_Narrative__c,
                    Davis_Bacon_Compliance__c, Technology_Commercializing__c, 
                    Budget_Issues_Contributing_Factors__c, 
                    Technical_Progress__c, General_Administration_Progress__c, Personnel_Issues_Progress__c, Technical_Administration_Narrative__c,
                    Milestone_Schedule_Progress__c, Budget_Issues__c, Departmental_Resources__c, Sub_Performer_Monitoring__c, Project_Renovations__c, EERE_Site_Visitor__c, Performers_Interviewed__c,
                    Budget_Developments__c, Procurement_Developments__c, Payroll_Developments__c, Equipment_Developments__c, Sub_Contract_Developments__c, Financial_Management_Developments__c,
                    Record_Developments__c, Performer_Dicussions__c, Best_Practices__c, Orientation_Meeting_Completed_Date__c, APM_Review_Comments__c, Actual_Site_Visit_Date__c,
                    Orientation_Meeting_Location__c, Orientation_Meeting_Notes__c, Orientation_Scheduled_Meeting_Date__c, Attendees__c, Invitees__c, Follow_Up_Meeting_Date__c, CAP_Related__c, CAP_Progress__c, CAP_Adequate_Actions__c,
                    Project_Management_Plan_Exists__c, Project_Management_Plan_Is_Current__c, Scope_Exists__c, Scope_Is_Current__c, Scope_Issues_or_Inconsistencies_Observed__c, 
                    Scope_Performance_Tracked_Exists__c, 
                    Scope_Performance_Tracked_Is_Current__c, 
                    Scope_Links_to_Budget_Exists__c, 
                    Scope_Links_to_Budget_Is_Current__c, 
                    Scope_Links_to_Schedule_Exists__c, Scope_Links_to_Schedule_Is_Current__c,
                    
                    Schedule_Performance_Tracked_Exists__c, Schedule_Performance_Tracked_Is_Current__c, 
                    
                    Schedule_Links_to_Budget_Exists__c, Schedule_Links_to_Budget_Is_Current__c, Budget_Detail_Exists__c,
                    Budget_Detail_Is_Current__c, Budget_Performance_Tracked_Exists__c, Budget_Performance_Tracked_Is_Current__c, 
                    
                    Programmatic_Risks_Exist__c, Programmatic_Risks_Are_Current__c,
                    
                    Project_Risks_Exist__c, Project_Risks_Are_Current__c, Project_Risk_Mitigation_Strategy_Exists__c, Research_Project_Progress_Reports_Exist__c, 
                    
                    Lessons_Learned__c, Overall_Performance_Observations__c, Scope_Observations__c, Schedule_Observations__c, Budget_Observations__c, 
                    Risk_Observations__c, Recommendation_Observations__c, Actions_for_the_Project_Lead_Observation__c,
                    IPR_Start_Date__c, IPR_End_Date__c, IPR_Review_Team__c, IPR_Requestor__c, IPR_Outcomes__c, IPR_Number__c, 
                    Scope_of_Project__c,
                    PMP_Issues_Inconsistencies_Observed__c,
                    Scope_Perf_Demonstrates_Proj_On_Track__c, Scope_Perf_Tracked_Issues_Observed__c, 
                    Scope_Links_to_Budget_Issues_Observed__c, Scope_Links_to_Sched_Issues_Observed__c, 
                    Project_Schedule_Exists__c, Project_Schedule_Is_Current__c, Project_Schedule_Issues_Observed__c, 
                    
                    
                    Sched_Perf_Demonstrates_Proj_On_Track__c, Sched_Perf_Tracked_Issues_Observed__c, 
                    
                    Sched_Links_to_Budget_Issues_Observed__c, 
                 Budget_Detail_Identified_Issues_Observed__c, 
                    Budget_Perf_Demonstrates_Proj_On_Track__c, Budget_Perf_Tracked_Issues_Observed__c, 
                    
                    Programmatic_Risks_or_Issues_Observed__c, 
                    Programmatic_Risk_MT_Strategy_Exists__c, Programmatic_Risk_MT_Strategy_is_Current__c, Prog_Risk_MT_Strat_Issues_Observed__c, 
                    
                    Project_Risks_Issues_Observed__c, 
                    Project_Risk_MT_Strategy_Is_Current__c, Proj_Risk_MT_Strategy_Issues_Observed__c, 
                    Research_Proj_Prog_Reports_Are_Current__c, 
                    Res_Prog_Reports_Demo_Proj_On_Track__c, Res_Proj_Prog_Report_Issues_Observed__c, 
                    Progress_Review_Exists__c, Progress_Review_is_Current__c, Progress_Review_Issues_Observed__c, 
                    Active_Proj_Mgmt_Visit_Report_Exists__c, Active_Proj_Mgmt_Visit_Report_Current__c, Active_Proj_Mgmt_Visit_Report_On_Track__c, Active_Proj_Mgmt_Visit_Report_Iss_Obs__c, 
                    Research_Proj_Prog_Reports_Observations__c, Progress_Review_Observations__c, Review_Locked__c
                    FROM EERE_Review__c
                    WHERE Related_Project__c = :projectId AND (APM_Review_Status__c != null OR IPR_Review_Status__c = 'Completed' OR Progress_Review_Status__c = 'Completed') ORDER BY CreatedDate]){
                ReviewWrapper w_review = new ReviewWrapper(r, this);
                reviews.add(w_review);
        }
                    }
        
        else if(!isPortalUser){
            showContentDialog = false;
            reviews = new List<ReviewWrapper>();
            for (EERE_Review__c r : [SELECT Name, OwnerID, RecordTypeID, Review_Type__c, APM_Review_Status__c, CreatedDate, Purpose__c, Scope_Description__c, Scheduled_Visit_Date__c, EERE_Site_Visitor_New__c, Performers_Interviewed_New__c,
                    Worksites_Visited__c, APM_Completion_Date__c,
                    Progress_Review_Due_Date__c, Progress_Review_Completed_Date__c, 
                    Project_Progress_Scope__c, Scope_Contributing_Factors__c, Cost_Deviated_Ten_Percent__c, Schedule_Deviation_Ten_Percent__c,
                    Severity_of_Budget_Deviation__c, 
                    Severity_of_Schedule_Deviation__c, Budget_Contributing_Factors__c, Schedule_Contributing_Factors__c, Adequate_Corrective_Action_Plan_progress__c, PPD_Updates__c, High_Priority_Project__c,
                    Progress_Review_Comments__c, Progress_Review_Status__c,
                    Report_Due_Date__c, Review_Scope__c, Related_Project__c, Meet_Goals_Objectives__c, Scope_Issues__c, 
                    Recommendations__c, IPR_Review_Status__c, IPR_Best_Practices__c,
                    Schedule_Issues__c, Internal_Comments__c, Performer_Comments__c,
                    NEPA_Compliance__c, 
                    NEPA_Requirements_Progress__c, Financial_Narrative__c,
                    Davis_Bacon_Compliance__c, Technology_Commercializing__c, 
                    Budget_Issues_Contributing_Factors__c, 
                    Technical_Progress__c, General_Administration_Progress__c, Personnel_Issues_Progress__c, Technical_Administration_Narrative__c,
                    Milestone_Schedule_Progress__c, Budget_Issues__c, Departmental_Resources__c, Sub_Performer_Monitoring__c, Project_Renovations__c, EERE_Site_Visitor__c, Performers_Interviewed__c,
                    Budget_Developments__c, Procurement_Developments__c, Payroll_Developments__c, Equipment_Developments__c, Sub_Contract_Developments__c, Financial_Management_Developments__c,
                    Record_Developments__c, Performer_Dicussions__c, Best_Practices__c, Orientation_Meeting_Completed_Date__c, APM_Review_Comments__c, Actual_Site_Visit_Date__c,
                    Orientation_Meeting_Location__c, Orientation_Meeting_Notes__c, Orientation_Scheduled_Meeting_Date__c, Attendees__c, Invitees__c, Follow_Up_Meeting_Date__c, CAP_Related__c, CAP_Progress__c, CAP_Adequate_Actions__c,
                    Project_Management_Plan_Exists__c, Project_Management_Plan_Is_Current__c, Scope_Exists__c, Scope_Is_Current__c, Scope_Issues_or_Inconsistencies_Observed__c, 
                    Scope_Performance_Tracked_Exists__c, 
                    Scope_Performance_Tracked_Is_Current__c, 
                    Scope_Links_to_Budget_Exists__c, 
                    Scope_Links_to_Budget_Is_Current__c, 
                    Scope_Links_to_Schedule_Exists__c, Scope_Links_to_Schedule_Is_Current__c,
                    
                    Schedule_Performance_Tracked_Exists__c, Schedule_Performance_Tracked_Is_Current__c, 
                    
                    Schedule_Links_to_Budget_Exists__c, Schedule_Links_to_Budget_Is_Current__c, Budget_Detail_Exists__c,
                    Budget_Detail_Is_Current__c, Budget_Performance_Tracked_Exists__c, Budget_Performance_Tracked_Is_Current__c, 
                    
                    Programmatic_Risks_Exist__c, Programmatic_Risks_Are_Current__c,
                    
                    Project_Risks_Exist__c, Project_Risks_Are_Current__c, Project_Risk_Mitigation_Strategy_Exists__c, Research_Project_Progress_Reports_Exist__c, 
                    
                    Lessons_Learned__c, Overall_Performance_Observations__c, Scope_Observations__c, Schedule_Observations__c, Budget_Observations__c, 
                    Risk_Observations__c, Recommendation_Observations__c, Actions_for_the_Project_Lead_Observation__c,
                    IPR_Start_Date__c, IPR_End_Date__c, IPR_Review_Team__c, IPR_Requestor__c, IPR_Outcomes__c, IPR_Number__c, 
                    Scope_of_Project__c,
                    PMP_Issues_Inconsistencies_Observed__c,
                    Scope_Perf_Demonstrates_Proj_On_Track__c, Scope_Perf_Tracked_Issues_Observed__c, 
                    Scope_Links_to_Budget_Issues_Observed__c, Scope_Links_to_Sched_Issues_Observed__c, 
                    Project_Schedule_Exists__c, Project_Schedule_Is_Current__c, Project_Schedule_Issues_Observed__c, 
                    
                    
                    Sched_Perf_Demonstrates_Proj_On_Track__c, Sched_Perf_Tracked_Issues_Observed__c, 
                    
                    Sched_Links_to_Budget_Issues_Observed__c, 
                 Budget_Detail_Identified_Issues_Observed__c, 
                    Budget_Perf_Demonstrates_Proj_On_Track__c, Budget_Perf_Tracked_Issues_Observed__c, 
                    
                    Programmatic_Risks_or_Issues_Observed__c, 
                    Programmatic_Risk_MT_Strategy_Exists__c, Programmatic_Risk_MT_Strategy_is_Current__c, Prog_Risk_MT_Strat_Issues_Observed__c, 
                    
                    Project_Risks_Issues_Observed__c, 
                    Project_Risk_MT_Strategy_Is_Current__c, Proj_Risk_MT_Strategy_Issues_Observed__c, 
                    Research_Proj_Prog_Reports_Are_Current__c, 
                    Res_Prog_Reports_Demo_Proj_On_Track__c, Res_Proj_Prog_Report_Issues_Observed__c, 
                    Progress_Review_Exists__c, Progress_Review_is_Current__c, Progress_Review_Issues_Observed__c, 
                    Active_Proj_Mgmt_Visit_Report_Exists__c, Active_Proj_Mgmt_Visit_Report_Current__c, Active_Proj_Mgmt_Visit_Report_On_Track__c, Active_Proj_Mgmt_Visit_Report_Iss_Obs__c, 
                    Research_Proj_Prog_Reports_Observations__c, Progress_Review_Observations__c, Review_Locked__c
                    FROM EERE_Review__c
                    WHERE Related_Project__c = :projectId ORDER BY CreatedDate]){
                ReviewWrapper w_review = new ReviewWrapper(r, this);
                reviews.add(w_review);
            }
        }
            isRecords = !reviews.isEmpty();
        }
        //findingHandlers = new List<FindingHandler>();
        findingList = new list<EERE_Finding__c>([
                SELECT Name, Finding_Description__c, Review__c, Finding_Type__c, Finding_Area__c, Finding_Source__c, Finding_Status__c, Funds_Impacted__c, Compliant__c, Corrective_Measures_Summary__c,
                Opened_Date__c, Closed_Date__c, Internal_Notes__c, Possible_CAP_Needed__c, Related_CAP__r.Name, CAP_Required__c, Corrective_Measures__c, Project__c, Related_CAP__c,
                Required_Corrections__c, CAP_Review_Recommended__c, Compliance_Comments__c, Area_of_Non_Compliance__c, Description_of_Non_Compliance__c, Compliance_Determination_Date__c,
                Corrective_Actions_to_be_Taken__c, Notice_of_Non_Compliance_Date__c, Consequences_for_Failure_to_Comply__c, Show_to_Performer__c
                FROM EERE_Finding__c
                WHERE Project__c = :projectId AND Review__c = :selectedReviewID]); 
                
                if (findingList.isEmpty())
                {
                    isRecords = false;
                }
                else
                {
                    for (EERE_Finding__c a : findingList)
                    {
                       // FindingHandler rh = new FindingHandler(a, this);
                       // findingHandlers.add(rh);
                    }
                }
     
        
    }
    
   public void meetingInit(){
   list<EERE_Meeting__c> items = new list<EERE_Meeting__c>([
            SELECT Name, ID, Project__c,
                Orientation_Scheduled_Meeting_Date__c, Attendees__c, Follow_Up_Meeting_Date__c,
                Invitees__c, Orientation_Meeting_Completed_Date__c, Orientation_Meeting_Location__c, Orientation_Meeting_Notes__c
            FROM EERE_Meeting__c
            WHERE Project__c = :projectId
            ]);

        map<string, list<ContentDocument>> comToDocMap = EEREAttachmentUtility.getAttachmentMap(items);

        meetingHandlers = new list<MeetingHandler>();
        for (EERE_Meeting__c c : items) {
            list<ContentDocument> docs = comToDocMap.get( EEREAttachmentUtility.conformID(c.Id) );
            if (docs == null) {
                docs = new list<ContentDocument>();
            }
            meetingHandlers.add( new MeetingHandler(c, this, docs) );
        }
                updateMeetingReferer();
   }
    
      public void setSelectedRecord(EERERecordHandler rh) {
        selectedMeeting = (MeetingHandler)rh;
        //selectedFinding = (FindingHandler)rh;
    }
    
    public void saveMeetingTest(){
         meetingInit();
         if(meetingHandlers.size()>0 && selectedMeeting.meeting.id==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You already have an Orientation Meeting for this Project'));
         }
         else {
            selectedMeeting.saveRecord();
            // isMeetingSuccess = false;
         }
    
    
    }
    
    public void createFinding(){
    selectedFinding = new EERE_Finding__c(
            Project__c = projectId
            
            );
            selectedFinding.Review__c = selectedReviewId;
            /*if(Finding.Required_Corrections__c == 'Corrective Measure'){
            newFinding.Finding_Status__c = 'CM Required';
            }
            else if (newFinding.Required_Corrections__c == 'Possible Corrective Action Plan'){
            newFinding.Finding_Status__c = 'Pending Team Review';
            }
            else{
                newFinding.Finding_Status__c = 'Open';
            }*/
        //newFinding.Finding_Status__c = 'Open';
        //selectedFinding = new FindingHandler(newFinding, this);
        //selectedFinding.editRecord();
       // insert newFinding;
       //selectedFinding = newFinding;
  		//newFinding = selectedFinding;
        initialize();
    
    }
    
    public void editFinding(){
   		System.debug('selectedRecordId ' + selectedRecordId);
        if (selectedRecordId!=null) {
            for (EERE_Finding__c rec:findingList) {
                if (rec.id==selectedRecordId) {
                    System.debug('selectedRecordId - matched' + rec.id);
                    selectedFinding = rec;
                    break;
                }
            }
        }
        isEditMode = true;
    
    }
    
        public void saveFinding(){

    		if(selectedFinding.Required_Corrections__c == 'Corrective Measure'){
            selectedFinding.Finding_Status__c = 'CM Required';
            }
            else if (selectedFinding.Required_Corrections__c == 'Possible Corrective Action Plan' && selectedFinding.CAP_Review_Recommended__c==null && selectedFinding.CAP_Required__c==null){
            selectedFinding.Finding_Status__c = 'Pending Team Review';
            }
            else if (selectedFinding.Required_Corrections__c == 'Possible Corrective Action Plan' && selectedFinding.CAP_Review_Recommended__c=='Yes' && selectedFinding.CAP_Required__c==null){
            selectedFinding.Finding_Status__c = 'Pending CO Review';
            }
            else if (selectedFinding.Required_Corrections__c == 'Possible Corrective Action Plan' && selectedFinding.CAP_Review_Recommended__c=='Yes' && selectedFinding.CAP_Required__c=='Yes' && selectedFinding.Related_CAP__c==null){
            selectedFinding.Finding_Status__c = 'CAP Required';
            }
             else if (selectedFinding.Required_Corrections__c == 'Possible Corrective Action Plan' && selectedFinding.CAP_Review_Recommended__c=='Yes' && selectedFinding.CAP_Required__c=='Yes' && selectedFinding.Related_CAP__c!=null){
            selectedFinding.Finding_Status__c = 'Monitoring CAP';
            }
            else{
                selectedFinding.Finding_Status__c = 'Open';
            }

    try {
            Database.upsert(selectedFinding);
            selectedFinding = new EERE_Finding__c();
        	isEditMode = false;
        	initialize();
            
            
        } catch (DMLException ex) {
            ApexPages.addMessages(ex);
            isEditMode = true;
            return;
        }
        
    }
    
    public void cancelFinding(){
   		selectedFinding = new EERE_Finding__c();
        isEditMode = true;
    
    }
    
    
    public void dummy(){}
    
        public void createMeeting() {
    //    if(meetingHandlers==null){
        EERE_Meeting__c newMeeting = new EERE_Meeting__c(
            Project__c = projectId
            
            );
        selectedMeeting = new MeetingHandler(newMeeting, this);
        selectedMeeting.editRecord();
        if(newMeeting!=null)
        {
        newM=false;
        }
        else{
        newM=true;
        }
        initialize();
   //     }
      //  else if(meetingHandlers!=null) 
       // {
       //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You already have an Orientation Meeting for this Project'));
        
      //  }
    }
    
     public class MeetingHandler extends EERERecordHandler{
        public EERE_Meeting__c meeting {get; private set;}
        public list<ContentDocument> attachments {get; private set;}
        
        public MeetingHandler(EERE_Meeting__c meeting, EEREIRecordViewer recordViewer) {
            this(meeting, recordViewer, new list<ContentDocument>());
        }
        
        
        public MeetingHandler(EERE_Meeting__c meeting, EEREIRecordViewer recordViewer, list<ContentDocument> attachments){
            super(meeting, recordViewer);
            this.meeting = meeting;
            this.attachments = attachments;
        }  
    }
    
    public void setReview(){
    createNewReview = false;
    initialize();
    }

    public void createReview() {
        newReview = new ReviewWrapper(this);
        newReview.review.Related_Project__c = projectId;
        isSuccess = false;
        
        createNewReview = true;
       
    }
    
       public void doUpdate(){
       
                if (currentReview.Review_Type__c=='Progress Review' && currentReview.Project_Progress_Scope__c==null) {
                editSuccess = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'"Is Project progressing within scope?" is required.')); 
                
                }

                else{
                    try {
                          
                        update currentReview;
                        //Database.SaveResult saveResult = Database.Update(currentReview);
                        //System.debug('test' + saveResult);
                        editSuccess = true;
                        initialize();
                        
                        } catch (Exception e) 
                        {	
                        	editSuccess = false;
                        	System.debug('HELLO EXCEPTION');
                            ApexPages.addMessages(e);

                        }
                         
                       
                    }
        }
        
	public void cancelEdit(){
	initialize();
	}
    
    public void cancelNew(){
    newReview = new ReviewWrapper(null);
    
    }
     public void toggleEdit(){
            editing=true;
            editMode = true;
        }
    
        public void lockReview(){
        currentReview.Review_Locked__c = true;
        
        if (currentReview.Review_Type__c== 'Site Visit') {
               currentReview.APM_Review_Status__c = 'Closed';
             
            } else if (currentReview.Review_Type__c=='Independent Project Review')
            
            {
                currentReview.IPR_Review_Status__c = 'Completed';
            
            } else if (currentReview.Review_Type__c=='Progress Review')
            
            {
                currentReview.Progress_Review_Status__c = 'Completed';
            
            }
            try {
                      
                Database.SaveResult saveResult = Database.Update(currentReview);
                System.debug('test' + saveResult);
                editSuccess = true;
                initialize();
                } catch (Exception e) {
                    ApexPages.addMessages(e);
                    //editSuccess = false;
                        return;
                }
               // editing = false;
        }
        
         public void unlockReview(){
        currentReview.Review_Locked__c = false;
        
        if (currentReview.Review_Type__c== 'Site Visit') {
               currentReview.APM_Review_Status__c = 'In Progress';
             
            } else if (currentReview.Review_Type__c=='Independent Project Review')
            
            {
                currentReview.IPR_Review_Status__c = 'In Progress';
            
            } else if (currentReview.Review_Type__c=='Progress Review')
            
            {
                currentReview.Progress_Review_Status__c = 'In Progress';
            
            }
            try {
                      
                Database.SaveResult saveResult = Database.Update(currentReview);
                System.debug('test' + saveResult);
                editSuccess = true;
                initialize();
                } catch (Exception e) {
                    ApexPages.addMessages(e);
                    //editSuccess = false;
                        return;
                }
               // editing = false;
                
        }
    
    
    
  
    
    public PageReference linkContent(){ 
        PageReference pageRef = new PageReference('/apex/eerecontentlink?id='+reviewId+'&type=Review');
        return pageRef;
    }
    
    
    public void afterContentUpload(){
        showContentDialog = false;
        initialize();
    }
    
    public void showAddContentDialog(){
        showContentDialog = true;
    }
    
    public void loadContent(){
        // Map to store links
        Map<id, EERE_Content_Link__c> links = new Map<id, EERE_Content_Link__c>();
        contentList = new List<EEREContentItem>();  
        
        // grab content for this object
        if(!EERESOQLUtils.isPortalUser()) {
            for (EERE_Content_Link__c link: [Select ContentDocumentId__c, LinkedEntityId__c, LinkedEntityType__c
                                                        From EERE_Content_link__c
                                                        Where LinkedEntityId__c=: EEREAttachmentUtility.conformID(currentReview.id)]){                                               
                links.put(link.ContentDocumentId__c, link);         
            } 
        } else {
             for (EERE_Content_Link__c link: [Select ContentDocumentId__c, LinkedEntityId__c, LinkedEntityType__c
                                                        From EERE_Content_link__c
                                                        Where LinkedEntityId__c=: EEREAttachmentUtility.conformID(currentReview.id)
                                                        AND Share_with_Performer__c=true]){                                               
                links.put(link.ContentDocumentId__c, link);         
            } 
        }      
                            
        for(ContentDocument doc: [Select c.Title, c.SystemModstamp, c.PublishStatus, c.ParentId, c.OwnerId, c.LatestPublishedVersionId, 
                                    c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.IsArchived, c.Id, c.CreatedDate, c.CreatedById, 
                                    c.ArchivedDate, c.ArchivedById, c.LatestPublishedVersion.id, c.latestpublishedversion.contenturl,
                                    c.LastModifiedBy.LastName, c.LastModifiedBy.FirstName, c.CreatedBy.FirstName, c.CreatedBy.LastName 
                                    From ContentDocument c 
                                    Where c.id IN : links.keySet()
                                    ORDER BY c.Title]){
                                        
            EERE_Content_link__c link = links.get(doc.id);
            EEREContentItem content = new EEREContentItem(doc); 
            contentList.add(content);
        }
        
        hasContent = (!contentList.isEmpty());      
    }
    
   /*  public class FindingHandler extends EERERecordHandler{
        public EERE_Finding__c finding {get; private set;}
        //public Boolean isSelected             {get;set;}
        
        public FindingHandler(EERE_Finding__c finding, EEREIRecordViewer recordViewer){
            super(finding, recordViewer);
            this.finding = finding;
            
        } 
        
    }*/
    
    
   
    
    public class ReviewWrapper{
        public EERE_Review__c review {get; private set;}
        public List<EEREContentItem> contentList {get; private set;}
        public Boolean hasContent {get; private set;}
        private EEREReviewController reviewController;
        public boolean editing{get;set;}
        public Boolean isSuccess {get; private set;}
        //public Boolean isRecords {get; private set;}
        
        public ReviewWrapper(EEREReviewController controller){
            this.review = new EERE_Review__c();
            reviewController = controller;
            editing = false;
            isSuccess = false;
            reviewController.isRecords = false;
   
        }
        
        public ReviewWrapper(EERE_Review__c review, EEREReviewController controller){
            this.review = review;
            reviewController = controller;
            editing = false;
            isSuccess = false;
            reviewController.isRecords = false;
        
        }  
        
        public void toggleEdit(){
            editing=!editing;
        }
        
        public void cancelNew2(){
            this.review = new EERE_Review__c();
    
    }    

    

      public void doSave(){
               if (review.Review_Type__c== 'Site Visit' && review.Scheduled_Visit_Date__c != null) {
               review.APM_Review_Status__c = 'Scheduled';
             
            } else if (review.Review_Type__c=='Independent Project Review')
            
            {
                review.IPR_Review_Status__c = 'Initiated';
            
            } else if (review.Review_Type__c=='Progress Review')
            
            {
                review.Progress_Review_Status__c = 'Created';
            
            }
                try {
                        Database.SaveResult saveResult = Database.Insert(review);
                } catch (Exception e) {
                    ApexPages.addMessages(e);
                        return;
                }
                editing=false;
                isSuccess = true;
                reviewController.isRecords = true;
                reviewController.initialize();
                cancelNew2();
        } 
        
    
        
        
    }
}