SBU-Gaze-Detection-Description dataset v0.1
================================================

This package contains the SBU-Gaze-Detection-Description dataset version 0.1 for Matlab. If you use this dataset in your work, please cite the following paper.

	Kiwon Yun, Yifan Peng, Dimitris Samaras, Gregory J. Zelinsky, and Tamara L. Berg, 
	Studying Relationships Between Human Gaze, Description, and Computer Vision, 
	Computer Vision and Pattern Recognition (CVPR) 2013.

For questions and comments, please email Kiwon Yun <kyun@cs.stonybrook.edu>
Data written: Apr 28, 2013	

================================================

Contents
	data/pascal_sentence	
		Data for the PASCAL dataset
		Images and descriptions are from http://vision.cs.uiuc.edu/pascal-sentences/
		Eye movements were recorded from three human observers
							
	data/sun09
		Data for the SUN09 dataset
		Images are from http://people.csail.mit.edu/myungjin/HContext.html
		Eye movements were recorded from eight human observers
		Description 'set 1' were collected from the same observers.
		Description 'set 2' were collected from Amazon's Mechanical Turk service
		Selected scenes:
			bar, bathroom, bedroom, kitchen, dinning room, classroom, living room, office
		Selected objects: 
			bathtub, bed, bouquet, box, carpet/rug, cabinet/cupboard, chair/stool, curtain, desk, dishwasher, drawer, door, microwave/oven, person, picture/painting, plant , refrigerator, sofa, tv/screen, toilet, window
	
================================================

Data format

The file `data/{dataset_name}/fixations/{filename}.mat` contains a struct array `fixations`. The struct has the following fields.

	filename			the name of image file.
	subject_ids			subject id.
	fixation
		fix_X			x coordinate of the fixation
		fix_Y			y coordinate of the fixation
		duration		fixation duration
		

The file `data/{dataset_name}/descriptions/{filename}.mat` contains a struct array `description_data`. The struct has the following fields.

	subject_ids		subject id.
	descriptions		described sentences
	extracted_words		extracted nouns by POS tagger
	extracted_objects	extracted object list by WordNet similarity
	extracted_scenes	extracted scene list by WordNet similarity
	
	