If you use this work, please cite: Koehler, K., Guo, F., Zhang, S., & Eckstein, M. P. (2014). What do saliency models predict? Journal of Vision, 14(3):14, 1–
27, http://www.journalofvision.org/content/14/3/14, doi:10.1167/14.3.14.

You can access the article at: http://www.journalofvision.org/content/14/3/14.full


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Contact info: 
For questions or comments please contact 
Katie Koehler (koehler@psych.ucsb.edu) [and/or] 
Miguel Eckstein (eckstein@psych.ucsb.edu)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Contents of folder:

Cues (folder):  Images with the cue names for the object search task embedded into a mid-level grey background.
Cued objects are absent in images 1-400 and present in images 401-800. _Left and _Right suffixes indicate the
expected location of the object based on the context in the image (either on the left half or right half of the
image). Odd numbered images contain expected object locations on the left half, even on right.

Cues (text file): text file with all cues and image numbers listed on a separate line. Same as cues 
embedded in images in Cues folder (in case you prefer to generate the cue text yourself in an experiment).

Images: 405x405px experimental images (used for all tasks).

ObserverData.mat: Matlab file containing all experimental data (explicit judgments and eye movements) in the 
form of image coordinates. Variables in this file:
	explicit_judg:  matrix containing click locations for each observer in the explicit judgment task. 
			rows index different observers, columns index different images, 3rd dim=coords (x=1, y=2)
	freeview_x/y, objsearch_x/y, salview_x/y: eye movements locations for each eye movement task. Rows
			index different observers, columns index different images, 3rd dim indexes eye movement number
			within a single trial. x- and y-coordinates are recorded in separate matrices as labeled.

All text files are labeled by task and contain the same information as the matlab file, along with 
observer number, image number, and fixation number (in the case of eye movement data). 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Notes about individual images:

The resolution and content of each image varies. Depending on your purpose, the factors listed below may
prompt you to exclude a few images from use. If you have recommendations for information to include
about specific images, please notify the researchers (contact info listed above).

Images with disrupted aspect ratios:
Image 35
Image 64
Image 184
Image 427

Images with noticable artifacts/pixelation:
Image 97
Image 108
Image 184
Image 195
Image 234
Image 251
Image 545

Images with highly sparse content (repetitive background with no clear standout region or foreground object):
Image 55
Image 79
Image 92
Image 97
Image 144
Image 147
Image 153
Image 182
Image 232
Image 520

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%