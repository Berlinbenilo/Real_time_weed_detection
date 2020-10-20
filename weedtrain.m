load ('done.mat');
weeds=selectLabels(gTruth,'weed');
addpath('data2');
%%
trainingdata= objectDetectorTrainingData(weeds,...
    'WriteLocation','data2');
detector2=trainACFObjectDetector(trainingdata);
save('out2.mat','detector2');

rmpath('data2');
