Ex1CollectedResults = 

1x25 struct array with fields:
    BeginTime				Time Experiment Commenced as 'HH_mm_ss'
    BlnkTIME				Time(ms) of the blank Scene 
    Condition				Group in which participant was for determaining the target absent trials)
    Date				Date of experiment
    FixTIME				Time(ms) that the fixation cross before target was present on Screeen
    NoOfBlocks				Number of blocks
    NoPracScenes			Number of practice scenes
    ParAge				Age of participant
    ParGender				Gender of Participant
    ParID				Participant Identifer
    ParType				Type of particpant (used so same data sturucter can be applied to computational Models). Always human for this dataset
    PracticeFolder			Location of practice Scene on the experimental Machine
    PracticeList			A Structer of the results of the 6 practice Scenes (the data is not used)
    Scale				N/A 
    SceneHeight				The hight, in pixel, of the Scene.
    SceneTIME				Maximum time for which the Scene is aloud to be present before Scene times out.
    SceneWidth				The width, in pixels, of teh Scene.
    ScenesPerBlock			The number of scenes in a block
    ScreenHeight			The hight, in pixels, of the Screen resolution
    ScreenWidth				The width, in pixels, of the Screen resolution
    TargTIME				Time(ms) that the target for a trial is displayed
    ThisDataFolder			Folder on Experimental computer where raw data is stored 
    TrialFolder				Folder on Experimental computer where Scenes are stored
    TrialOrder				Structer of trial results, ordred by Scene ID.
    Results				An array, 'TrialSequence', that indicate the order and block in which the trials were presented.



Ex1CollectedResults(1).TrialOrder

ans = 

1x120 struct array with fields:
    SceneID				The Scene ID
    TargetPresent			Binanry Flag indicating if the trial was Target Present (1) or Target Absent(0) trial
    SourceFile				Name of the File used as the source of teh scene images
    TrialID				The order position of the the trial in the Block
    BlockID				The Block in which the trial was present
    SceneRect				The [Top,Left,Bottom,Right] location of the Scene inside the Source Image
    Targ				The [Top,Left,width,Height] Location of the Present Target, inside teh Scene
    NonTarg				The [Top,Left,width,Height] Location of the AbsentTarget, inside the Source image
    SaccadeList				A structure of the fixations for the trial
    SceneOn				Time(ms) that the Scene was first presented on teh screen (intereger representatation of master Clock)
    Response				The ID of teh button pressed for response. 
    ResponseTime			Time(ms) the the Response was made
    SceneOff				Time(ms) Scene was removed from the Screen

 Ex1CollectedResults(1).TrialOrder(1).SaccadeList

ans = 

1x14 struct array with fields:
    StartTime				The Time(ms) the fixation Lands at teh location	
    EndTime				The Time(ms) the fixation leaves the loaction
    Duration				Total tiem of fixation
    XPos				X location of fixation (in SCREEN Coordinates)
    YPos				Y location of fixation (in SCREEN Coordinates)
    PupilSize				Not Used
    AfterResponse			Binary indicating that the fixation landed after the button press for response.



Note that for some participants, the Scene Timed out, and the Trials were repeated. Both the trials are recorded so .trialorder is longer than 120. 
The structure in these cases is slightyl diffrent and has two additional feilds

    TimeOut				Binary indicating that this trial timed out and was replaced.
    Replaced				Trial ID in Block that it was replaced by

There are present, but the ordered trial set typically has teh origonal unfinshed trial first in order then the replacement trial. 


