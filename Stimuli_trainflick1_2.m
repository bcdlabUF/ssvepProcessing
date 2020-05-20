 function trainflick1_2(subNo)
% TO  START, TYPE: trainflick1(subNo) into Command Window
% 1. %%%%%% set the settings for keyb and clock, same for each experiment
          clc;
        rand('state',sum(100*clock)); % reseed the random-number generator for each expt.
  
  
prompt = {'Subject Number'};
defaults = {'1'};
answer = inputdlg(prompt,'subject',1,defaults);
if(size(answer) ~= 1)
       clc;   
    disp('Exiting.');  
    return;   
end  
  [subject] = deal(answer{:}); 
 
% which order?
orderArray = {'1a','1b','1c','1d','1e','1f','2a','2b','2c','2d','2e','2f','3a','3b','3c','3d','3e','3f'};
[selectionIndex3, leftBlank] = listdlg('PromptString', 'Select an order to run:', 'SelectionMode', 'single', 'ListString', orderArray);
order= orderArray{selectionIndex3};

    
  allfacepath = 'C:\Users\vpixx\Desktop\infant flicker\KDEF\';
  objectpath = 'C:\Users\vpixx\Desktop\infant flicker\allobjects\';
  
  
if strcmp(order, '1a') || strcmp(order, '1b') ||  strcmp(order, '1c')||  strcmp(order, '1d')||  strcmp(order, '1e')||  strcmp(order, '1f')
  
  facepath ='C:\Users\vpixx\Desktop\infant flicker\KDEF\order1';  
  indpath = 'C:\Users\vpixx\Desktop\infant flicker\species1\';
  catpath = 'C:\Users\vpixx\Desktop\infant flicker\species2\';
  untpath = 'C:\Users\vpixx\Desktop\infant flicker\species3\';

elseif strcmp(order, '2a') || strcmp(order, '2b') ||  strcmp(order, '2c')||  strcmp(order, '2d')||  strcmp(order, '2e')||  strcmp(order, '2f')
  facepath ='C:\Users\vpixx\Desktop\infant flicker\KDEF\order2'; 
  indpath = 'C:\Users\vpixx\Desktop\infant flicker\species2\';
  catpath = 'C:\Users\vpixx\Desktop\infant flicker\species3\';
  untpath = 'C:\Users\vpixx\Desktop\infant flicker\species1\';

elseif strcmp(order, '3a') || strcmp(order, '3b') ||  strcmp(order, '3c')||  strcmp(order, '3d')||  strcmp(order, '3e')||  strcmp(order, '3f')
  facepath ='C:\Users\vpixx\Desktop\infant flicker\KDEF\order3'; 
  indpath = 'C:\Users\vpixx\Desktop\infant flicker\species3\';
  catpath = 'C:\Users\vpixx\Desktop\infant flicker\species1\';
  untpath = 'C:\Users\vpixx\Desktop\infant flicker\species2\';
end
      

    
    
%     Connect to NetStation
    DAC_IP = '10.10.10.42';
    NetStation('Connect', DAC_IP, 55513);
    NetStation('Synchronize');
    NetStation('StartRecording');
        

        % files
        datafilename = strcat('flick2faces_1_',num2str(subNo),'.dat'); % name of data file to write to

        % check for existing file (except for subject numbers > 99)
        if subNo<99 && fopen(datafilename, 'rt')~=-1
            error('data files exist!');
        else
            datafilepointer = fopen(datafilename,'wt'); % open ASCII file for writing
        end
  
    
try
    AssertOpenGL;
    
    % get screen
    screens=Screen('Screens');
    screenNumber= 2
%     Screen('Preference', 'SkipSyncTests', 1);
    HideCursor;
    
    % Open a double buffered fullscreen window and draw a gray background 
    % to front and back buffers:
    [w, wRect]=Screen('OpenWindow',screenNumber, 0,[],32,2);
%    [w, wRect] = Screen('OpenWindow',screenNumber,gray);
   
    % returns as default the mean gray value of screen
    black=BlackIndex(screenNumber); 
    white = WhiteIndex(screenNumber);
    gray = white/2; 

    Screen('FillRect',w, gray, wRect);
    Screen('Flip', w);
    
     % Enable alpha blending with proper blend-function. We need it
    % for drawing of smoothed points:
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [center(1), center(2)] = RectCenter(wRect);
	fps=Screen('FrameRate',w)  % frames per second
    ifi=Screen('GetFlipInterval', w);
    if fps==0
       fps=1/ifi;
    end;
    
    black = BlackIndex(w);
    white = WhiteIndex(w);
    
    % set Text properties (all Screen functions must be called after screen
    % init
    Screen('TextSize', w, 20);
    
    % set priority - also set after Screen init
    priorityLevel=MaxPriority(w);
    Priority(priorityLevel);
    
    % create filemats-- for PC just need facemat= ls(facepath) for
    % example-- don't need the second part
    facemat=ls(facepath);
    indmat=ls(indpath);
    catmat=ls(catpath);
    untmat=ls(untpath);

    facemat= facemat(3:size(facemat,1),:);
    indmat= indmat(3:size(indmat,1),:);
    catmat= catmat(3:size(catmat,1),:);
    untmat= untmat(3:size(untmat,1),:);
    
  
if strcmp(order,'1a')|| strcmp(order,'2a')|| strcmp(order,'3a')
    indmat = indmat([1 5 6 7 8 9 10 11],:);
    catmat = catmat([1 5 6 7 8 9 10 11],:);
    untmat = untmat([1 5 6 7],:);
elseif strcmp(order,'1b')|| strcmp(order,'2b')|| strcmp(order,'3b')
    indmat = indmat([8 9 10 11 12 2 3 4],:);
    catmat = catmat([8 9 10 11 12 2 3 4],:);
    untmat = untmat([8 9 10 11],:);
elseif strcmp(order,'1c')|| strcmp(order,'2c')|| strcmp(order,'3c')
    indmat = indmat([12 2 3 4 1 5 6 7],:);
    catmat = catmat([12 2 3 4 1 5 6 7],:);
    untmat = untmat([12 2 3 4],:);
elseif strcmp(order,'1d')|| strcmp(order,'2d')|| strcmp(order,'3d')
    indmat = indmat([8 9 10 11 1 5 6 7],:);
    catmat = catmat([8 9 10 11 1 5 6 7],:);
    untmat = untmat([1 5 6 7],:);
elseif strcmp(order,'1e')|| strcmp(order,'2e')|| strcmp(order,'3e')
    indmat = indmat([12 2 3 4 8 9 10 11],:);
    catmat = catmat([12 2 3 4 8 9 10 11],:);
    untmat = untmat([8 9 10 11],:);
elseif strcmp(order,'1f')|| strcmp(order,'2f')|| strcmp(order,'3f')
    indmat = indmat([1 5 6 7 12 2 3 4 ],:);
    catmat = catmat([12 2 3 4 8 9 10 11],:);
    untmat = untmat([12 2 3 4],:);
end
    
    ntrials = size(facemat,1); 
    facemat = facemat(randperm(20),:);
    objectmat = [indmat; catmat; untmat];
    
% 4. %%%%   experiment proper

        % write message to subject
        Screen('DrawText', w, 'Please press mouse key to start ...', 10, 10, 255);
        Screen('Flip', w); % show text
        disp('Click mouse to start task')
        % wait for mouse press ( no GetClicks  :(  )
        buttons=0;
            while ~any(buttons) % wait for press
                [x,y,buttons] = GetMouse;
                % Wait 10 ms before checking the mouse again to prevent
                % overload of the machine at elevated Priority()
                WaitSecs(0.01);
            end
        % clear screen
        Screen('Flip', w);

        % wait a bit before starting trial           
        WaitSecs(1.000); %this was 2 secs
           
              
                 
                
                       % trial loop
                          for trial = 1:ntrials
                            
                         path1 = [allfacepath facemat(trial,:)];
                         path2 = [objectpath objectmat(trial,:)];



                             %serialbreak(s1,10);    
                Dist_images = dir(fullfile('/Images/Distractors/'));
        Dist_sounds = dir(fullfile('/Audio/Distractors/'));
        Dist_imagesList = 'Distractor_image.txt';
        Dist_soundList = 'Distractor_audio.txt';
        [Dist_imageNames] = textread(Dist_imagesList,'%s'); %#ok<*REMFF1>
        [Dist_soundNames] = textread(Dist_soundList,'%s'); %#ok<*REMFF1>
        nDist_files = length(Dist_imageNames);
        current_dist=randi(nDist_files);
        current_dist_image = Dist_imageNames(current_dist);
        current_dist_sound = Dist_soundNames(current_dist);
        dist_image_filename = strcat('/Images/Distractors/', char(current_dist_image));
        dist_sound_filename = strcat('/Audio/Distractors/', char(current_dist_sound));         
        
        disimagedata2 = imread(char(dist_image_filename));
        dissoundfile = dist_sound_filename;
        
                InitializePsychSound;
                Channels = 1;
                
                if current_dist ==1 
                    MySoundFreq = 32000;
                else
                    MySoundFreq = 48000;
                end
                disp(dissoundfile)
                diswavdata = transpose(audioread(dissoundfile));
                MySoundHandle = PsychPortAudio('Open',[],[],0,MySoundFreq,Channels);
                FinishTime1 = length(diswavdata)/MySoundFreq;PsychPortAudio('FillBuffer',MySoundHandle,diswavdata,0);
                %gives chance to use distractors by looking until mouse click
                [keyIsDown] = KbCheck(); %Listens for Keypresses
                [xpos,ypos,buttons] = GetMouse();
                while ~any(buttons) % Loops while no mouse buttons are pressed
                    [keyIsDown] = KbCheck();
                    [xpos,ypos,buttons] = GetMouse();
                    if any(keyIsDown)
                        disrand = char(randi(4));
                        
                        disimage = Screen('MakeTexture',w,disimagedata2);
                        
                        Screen('DrawTexture',w,disimage);
                        Screen('Flip',w);
                        
                        PsychPortAudio('Start',MySoundHandle,1,0,1);
                        
                        WaitSecs(FinishTime1);
                        
                        Screen(w, 'FillRect', gray);
                        Screen('Flip',w);
                        WaitSecs(.01);
                        KbEventFlush;
                    end
                    
                end
                KbEventFlush 
     disp('Click to present a trial')
    if strcmp(order,'1a')|| strcmp(order,'2a')|| strcmp(order,'3a')||strcmp(order,'1b')|| strcmp(order,'2b')|| strcmp(order,'3b')|| strcmp(order,'1c')|| strcmp(order,'2c')|| strcmp(order,'3c')
        if trial < 5 
            tag = 'it01' %ind trained
        elseif trial >4 && trial <9
            tag = 'iu02' %ind untrained
        elseif trial >8 && trial <13
            tag = 'ct03' %cat trained
        elseif trial > 12 && trial <17
            tag = 'cu04' %cat untrained
        elseif trial >16
            tag = 'un05' %untrained
        end
    elseif strcmp(order,'1d')|| strcmp(order,'2d')|| strcmp(order,'3d')||strcmp(order,'1e')|| strcmp(order,'2e')|| strcmp(order,'3e')||strcmp(order,'1f')|| strcmp(order,'2f')|| strcmp(order,'3f')
        if trial < 5 
            tag = 'iu02' %ind untrained
        elseif trial >4 && trial <9
            tag = 'it01' %ind trained
        elseif trial >8 && trial <13
            tag = 'cu04' %cat untrained
        elseif trial > 12 && trial <17
            tag = 'ct03' %cat trained
        elseif trial >16
            tag = 'un05' %untrained
        end
    end
        
                           WaitSecs (rand(1,1).*2 + 1) ;
                           NetStation('Event',tag, GetSecs, GetSecs+cputime, 'trls',1); % signals the beginning of a trial

                           NetStation('FlushReadbuffer');
                                    % call main flicker function
                                      [flickdur] = flick2faces_CB2(w, wRect, path1, path2);
                                                                    
                            
                            fprintf(datafilepointer,'%i %s %i %i %s %s \n', ...
                            subNo, ...
                            order, ...
                            trial, ...
                            flickdur, ...
                         facemat(trial,1:9), ...
                         objectmat(trial,1:7));
      
                    end % trials        
                           
  % write message to subject
    Screen('DrawText', w, 'Thank you very much for participating!', 10, 10, 255);
    Screen('DrawText', w, 'The experimenter will be with you shortly...', 10, 60, 255);
    Screen('Flip', w); % show text
    % wait for mouse press ( no GetClicks  :(  )
    buttons=0;
    while ~any(buttons) % wait for press
        [  thex,they,buttons] = GetMouse;
        % Wait 10 ms before checking the mouse again to prevent
        % overload of the machine at elevated Priority()
        WaitSecs(0.011);
    end
    
    
    % ready to end the exp   
    Screen('CloseAll');
    ShowCursor;
    fclose('all');
    Priority(0);
    
    
   
    NetStation('Synchronize');
    NetStation('StopRecording');
    NetStation('Disconnect', '10.10.10.42');
    %  fclose(s3);
    
    % End of experiment:
    return;
    %catch
    Screen('CloseAll');
    ShowCursor;
    fclose('all');
    Priority(0);
    %
    %      fclose(s3);
    psychrethrow(psychlasterror);
    
   
    NetStation('Synchronize');
    NetStation('StopRecording');
    NetStation('Disconnect', '10.10.10.42');
    
    Screen('CloseAll');
    ShowCursor;
    fclose('all');
catch
    
    Screen('CloseAll');
    ShowCursor;
    fclose('all');
    Priority(0);
    psychrethrow(psychlasterror);
    
%     fclose(s1); 
end