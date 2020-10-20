load('find.mat')
load('out.mat')
load('out2')
global scores
a=uigetfile('.mp4');
vidreader=VideoReader(a);
vidplayer=vision.DeployableVideoPlayer;
i=1; 
results=struct('Boxes',[],'Scores',[]);
while(hasFrame(vidreader))
    I=readFrame(vidreader);
    [bboxes,scores]=detect(detector,I,'Threshold',1);
    [bboxes1,scores1]=detect(detector1,I,'Threshold',1);
    [bboxes2,scores2]=detect(detector2,I,'Threshold',1);

    [~,idx]=max(scores);
    [~,idx1]=max(scores1);
    [~,idx2]=max(scores2);
    
    results(i).Boxes=bboxes;
    results(i).Scores=scores;

    if (scores1>40)
    annotation1=sprintf('%s,confidence %4.2f',detector1.ModelName,scores1(idx1));
    I=insertObjectAnnotation(I,'rectangle',bboxes1(idx1,:),annotation1,'LineWidth',4,...
    'TextBoxOpacity',0.9,'FontSize',18);
    else 
    annotation=sprintf('%s,confidence %4.2f',detector.ModelName,scores(idx));
    I=insertObjectAnnotation(I,'rectangle',bboxes(50,:),annotation,'LineWidth',4,...
    'TextBoxOpacity',0.9,'FontSize',18);
    end
    
    step(vidplayer,I)
    i=i+1;
    if i>1
        figure;
        plot(scores(:,1),'Marker','.','MarkerSize',20);
        xlim([1 14]);
        ylim([0 120]);
        title('confidence');xlabel('Tracking periods');ylabel('confidence value');
    end
    if scores(i>1)
    fprintf('weed detected\n');
    pause(10);
     port = serial('COM5') ;           % Creating serial port object now its connected to COM4
    get(port, 'Status');   
    fclose(port);
    get(port, 'Status'); 
% % 
% %Set connection properties
    port.Baudrate = 9600;      % Set the baud rate at the specific value
    set(port, 'Parity', 'none') ;     % Set parity as none
    set(port, 'Databits', 8) ;        % set the number of data bits
    set(port, 'stopBits', 1) ;        % set number of close bits as 1
    set(port, 'Terminator', 'LF') ; % set the terminator value to newline
    fopen(port);
    get(port, 'Status');
% writeDigitalPin(port, 'D3', 1);

    fprintf(port,'%c','A');
    pause(1);
    fclose(port);
    end
end
results=struct2table(results);
if scores(i>1)
    msgbox('weed detected');
    fprintf('weed detected\n');
end