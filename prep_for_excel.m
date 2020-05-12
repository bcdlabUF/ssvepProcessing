%% BCA
clear
clc

%set the counterbalance you want to run
CB = 2; %1 or 2
%set the path where your exported BCA files are located
MYpath='/Volumes/Ryan Data/FLICKER/BEES flicker/letswave/TRIAL AVG/CB2/';

cd(MYpath); %this will navigate you to the directory you specified

%set the pattern for the fiels you want to load
filematALL = dir('bca fft BEES_*_MAT.mat'); %creates a struct

filemat = {filematALL.name}'; %just pulls out the names of the files

%pre-allocates matrices that will hold all of the data
bca_ALL_face = zeros(109,size(filemat,1));
bca_ALL_obj = zeros(109,size(filemat,1));

%loop through all of the files
for j = 1:size(filemat,1)
    subject_string = deblank(filemat(j,:));
    Csubject = char(subject_string);
    filename = strcat(MYpath,Csubject);
    load(filename);

   if CB==1
    bca_ALL_face(:,j) = data(:,31); %6HZ
    bca_ALL_obj(:,j) = data(:,26); %5HZ
   elseif CB==2
    bca_ALL_face(:,j) = data(:,26); %5HZ
    bca_ALL_obj(:,j) = data(:,31); %6HZ
   end
   
end

% Once this is run, you'll have three important variables:
% filemat contains the filenames, bca_ALL_face is the responses
% to the face and, and bca_ALL_obj is the responses to the objects

% I copy and paste the contents in filemat into an excel sheet. There
% should be one file name per row. 

% Next, I create a new column in the excel sheet called face_obj.
% I type 'face' into the column next to the file names. Then I 
% paste a second copy of the filenames immediately below the first
% and type 'object' into the neighboring column. Now you know 
% where to paste your face and object responses.

% Next, I return to MATLAB and transpose the contents of bca_ALL_face 
% (If you've transposed correctly the matrix will be XX x 109- where
% XX is the length of your filemat matrix)
% and then copy and paste these values into the appropriate slot 
% in the excel file. Do the same for the bca_ALL_obj matrix

% I use excel's Text to Columns feature to split the filename column
% up into participant information.
 