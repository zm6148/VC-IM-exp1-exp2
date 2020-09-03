# This repository contains the raw data and data analysis scripts for Visual Crowding and Auditory Information Masking experiments

## Table of Contents
1. [Requirments](README.md#Requirments)
1. [Experiment procedure](README.md#Experiment-procedure)
1. [Questions?](README.md#questions?)

## requirements
Those scripts requires Matlab 2017a or later
Required tool box: Psychtoolbox-3 installation is required.


## Experiment procedure
There are 2 folders under in the directory. One is the pilot study, the other is the follow up study. Each of the folders contains all three experiments.  To run the study, run all three experiments from the original folder one after another following a balanced design for each subject.

Subject ID needs to be consistent for all three experiments. For the same subject, please use the same subject coding for all three experiment when asked.

# Experiment 1
This is the experiment of target detection with notched noise or notched tonal as masker. The corresponding .m file to run are 1) experiment_1_noise_IM.m, and 2) experiment_1_tonal_IM.m respectively. Subjects need to finish both task to complete experiment 1.
1)	When running the experiment_1_noise_IM.m script, matlab will ask for a subject ID, type in the subject code (TXX for example) and press enter. 
2)	A GUI window will open, this window will help you monitor subject progress in the experiment. Select the file with the subject code that was typed in and click on “load selected condition”. 
3)	Once loaded the experiment interface for the subject will appear. Subject needs to be trained on the target sound first. Click on the “Target Sound Training” button to begin training. 
4)	This is a target detection task in quiet. Instruct the subject to press the A button if using Xbox controller, or mouse left click if don’t have one. 
5)	Subject’s progress will show up on the monitoring GUI window. Once done, a window will pop up and subject can begin the experiment.
6)	Click on “stop training” to exit training. Instruct the subject to begin the experiment by clicking the “begin” button. 
7)	When the experiment started, subject will respond by clicking “yes” or “no” to indicate whether they can detect the target sound.
8)	Once finished a window will pop up. Click “stop experiment” to end the experiment.
9)	Repeat the same process when running experiment_1_tonal_IM.m
# Experiment 2
This the speech target identification task with another speech or noise as the masker. To run the experiment, run the script called experiment_2_speech_IM.m.
1)	Once ran, matlab will ask for a subject ID again, type in the ID and be consistent with the ID for this subject used for other 2 experiments (TXX for example).
2)	The interface will appear after pressing enter. This is the training block of 20 trials in total. This part of the experiment has only target speaker with no masker, instruct the subject to answer the question “where did baron go” after hearing the sentence with the structure “Ready Baron Go To [color] [number] now” by choosing the correct color and number. Once training is finished, press enter, the experiment inter face will show up.
3)	The experiment has 200 trials in total divided to 2 blocks of 100 trails each. Subject needs to perform the task in the same way by choosing correct color and number. But this time, there will be a speech or noise masker played at the same time.
4)	Once finished, press enter to end the experiment.
# Experiment 3
Experiment 3 is the visual crowding task. Run the script experiment_3_visual_crowding.m to begin.
1)	Once run, follow the instruction on the screen.
2)	This experiment needs to be ran twice, one for training, the second run’s result is used. To indicate that add ‘_1’ and ‘_2’ at the end of the subject code. For example: TXX_1, TXX_2.
3)	The script will end when the experiment is finished.
# Data analysis
Once all 3 experiments are finished, run “analysis_save_to_excel.m”. The summarized results will be stored in the excel file called “summarized_results.xlsx”.

## Questions?
Email us at ihlefeld@njit.edu
