clc;clear;close all
flag=0;
while flag==0
    prompt = {'\fontsize{13} Sampling frequency of signal:','\fontsize{13} Start of time scale:', '\fontsize{13} End of time scale:', '\fontsize{13} Number of break points:'}; %Subtitles
    dlgtitle = 'General Signal Generator'; %Title
    size = [1 50]; %Size to show whole title
    definput = {'100','0','0','0'}; %Default values 
    opts.Interpreter = 'tex'; %Enable tex markup to increase font
    answer = inputdlg(prompt,dlgtitle,size,definput,opts);
    samplingFrequency =  str2double(answer{1}); %convert string entered to double
    startTime =  str2double(answer{2}); 
    endTime =  str2double(answer{3}); 
    numberOfBreaks =  str2double(answer{4}); 
    positionMatrix = zeros(1,numberOfBreaks);
    if samplingFrequency<=0 || startTime>=endTime
       fprintf('Error in Input\n')
    else flag=1;
    end
end


for i=1:numberOfBreaks
    positionPrompt = { ['\fontsize{13}Position' num2str(i) '\fontsize{13} :']};
    dlgtitlePostion = 'Position Selector'; %Title
    definputPosition = {'0'}; %Default values 
    postions = inputdlg(positionPrompt,dlgtitlePostion,size,definputPosition,opts);
    positionMatrix(1,i) = str2double(postions{1});
end
positionMatrix(1,numberOfBreaks+1)=endTime;

choiceMatrix=zeros(1,numberOfBreaks+1);
startT=startTime;
X=[];

for i=1:numberOfBreaks+1
    str = ['Choose Signal for section ' num2str(i) ':'];
    choiceMatrix(1,i) = menu(str,'DC','Ramp','General Order Polynomial','Exponential','Sinusoidal');
    endT=positionMatrix(1,i);
    t1=linspace(startT,endT,(endT-startT)*samplingFrequency);
    dlgtitleData = 'Data Selector'; %Title
if choiceMatrix(1,i)==1
    prompt3 = { '\fontsize{13} Amplitude: '};
    definputData = {'0'}; %Default values 
    answer = inputdlg(prompt3,dlgtitleData,size,definputData,opts);
    amplitudeDC(1,i) =  str2double(answer{1});
    X1 = amplitudeDC(1,i) * ones(1,(endT-startT)*samplingFrequency);
else if choiceMatrix(1,i)==2
prompt3 = { '\fontsize{13}Slope: ', '\fontsize{13}Intercept:'};
    definputData = {'0','0'}; %Default values 
    answer = inputdlg(prompt3,dlgtitleData,size,definputData,opts);
    slopeRamp(1,i) =  str2double(answer{1});
    interceptRamp(1,i) =  str2double(answer{2});
    X1=slopeRamp(1,i)*t1 + interceptRamp(1,i);
else if choiceMatrix(1,i)==3
    prompt3={'\fontsize{13}Max Power'};
    definputData = {'0'}; %Default values 
    answer = inputdlg(prompt3,dlgtitleData,size,definputData,opts);
    p=[];
    for j=0:(str2num(answer{1}))
            promptAmplitude = {['\fontsize{13}Amplitude x^' num2str(str2num(answer{1})-j) '\fontsize{13}: ']};
            amplitude = inputdlg(promptAmplitude,dlgtitleData,size,definputData,opts);
            p=[p str2double(amplitude{1})];
    end
    X1=polyval(p, t1);
    
else if choiceMatrix(1,i)==4
prompt3 = { '\fontsize{13}Amplitude: ', '\fontsize{13}Exponent:'};
    definputData = {'0','0'}; %Default values 
    answer = inputdlg(prompt3,dlgtitleData,size,definputData,opts);
    amplitudeExp(1,i) =  str2double(answer{1});
    exponentExp(1,i) =  str2double(answer{2});
        X1=amplitudeExp(1,i)*exp(exponentExp(1,i)*t1);
else if choiceMatrix(1,i)==5
prompt3 = { '\fontsize{13}Amplitude: ', '\fontsize{13}Frequency:','\fontsize{13}Phase in Degree'};
    definputData = {'0','0','0'}; %Default values 
    answer = inputdlg(prompt3,dlgtitleData,size,definputData,opts);
    amplitudeSin(1,i) =  str2double(answer{1});
    frequencySin(1,i) =  str2double(answer{2});
    phaseSin(1,i) =  str2double(answer{3})*pi/180;
     X1 = amplitudeSin(1,i)*cos(2*frequencySin(1,i)*pi*t1 + phaseSin(1,i));
    end
    end
    end
    end
end
X=[X X1];
startT=positionMatrix(1,i);
end

t = linspace(startTime,endTime,(endTime-startTime)*samplingFrequency);
plot(t,X)
grid on
choice = menu('Do You Want To Perform Any Operation','YES', 'NO');
if choice==1
    XNew=X;
    tNew=t;
    flag=1;
    dlgtitleData = 'Operation Selector'; %Title
    definputData = {'0'}; %Default values 
    while flag==1
        operation = menu('Choose Operation','Amplitude Scaling', 'Time Reversal', 'Time Shift', 'Expand', 'Compress','Original Signal','None');
        if operation==1
            operationPrompt = { '\fontsize{13}Amplitude Scale By: '};
        op = inputdlg(operationPrompt,dlgtitleData,size,definputData,opts);
        XNew = str2double(op{1}) * XNew;
        else if operation==2
        tNew = -1*tNew;
        else if operation==3
            operationPrompt = { '\fontsize{13}Time Shift By: '};
        op = inputdlg(operationPrompt,dlgtitleData,size,definputData,opts);
        tNew = tNew + str2double(op{1});
        else if operation==4
            operationPrompt = { '\fontsize{13}Expand By: '};
        op = inputdlg(operationPrompt,dlgtitleData,size,definputData,opts);
        tNew = tNew * str2double(op{1});
        else if operation==5
            operationPrompt = { '\fontsize{13}Compress Signal By: '};
        op = inputdlg(operationPrompt,dlgtitleData,size,definputData,opts);
        tNew = tNew * (1/str2double(op{1}));
        else if operation==6
                tNew=t;
                XNew=X;
        else if operation ==7
                flag=0;
            end
            end
            end 
            end
            end
            end
        end
    plot(tNew,XNew)
    grid on;
    end
end

