
%function  Plot_all(currState, currImage, alltraj, dataBase,num_trck_lnd, i)
    %%%%%%%%%%%%%
    %%%plotting
  figure(3)
%    %%plot image with keypoints and landmarks

%dont use points behind camera
vect_to_lndmk = currState(3:5,:) - pos;
Rot_vec = repmat(R_C_W(3,:)',1,size(vect_to_lndmk,2));
pts_dir = dot(vect_to_lndmk,Rot_vec);
Cursate_pos =  currState(:,pts_dir > 0);
   

subplot(4,6,[1,2,3,7,8,9])
    imshow(currImage);    
    hold on;
    plot(currState(2, :),currState(1, :), 'gx', 'MarkerSize',3);
    plot(dataBase{1,end}(2,:),dataBase{1,end}(1,:),'rx', 'MarkerSize',2);
  title('Keypoints(RED), Landmarks(GREEN)')

%%%plot trajectory of last 20 frames and landmarks
  alltraj(:,i) = pos; 
     num_trck_lnd(1,i) = size(Cursate_pos(1,:),2);%vector of number of tracked landmarks at each frame
  
    if i<22
      last20 =  [alltraj(1,:);alltraj(3,:)];
        num_trck = num_trck_lnd; %for plotting number of tracked landmarks
        framevec = 1:i;
   else
       last20 = [alltraj(1,end-20:end);alltraj(3,end-20:end)];% get last 20 positions
               
        num_trck = num_trck_lnd(1,(end-20):end)%for plotting number of tracked landmarks
        framevec = (i - 20):i;
       
   end
  
   
   subplot(4,6,[4,5,6,10,11,12,16,17,18,22,23,24])
  plot(last20(1,:),last20(2,:), '-x','MarkerSize', 2) %plot last 20 positions
  hold on
     scatter(Cursate_pos(3, :), Cursate_pos(5, :), 4, 'k');% plot currently tracked landmarks 
       set(gcf, 'GraphicsSmoothing', 'on');
       axis equal;
      
       if min(last20(2,:))<min(Cursate_pos(5, :)) %set axes of plot based on current trajectory of camera
           zmin = min(last20(2,:));
           zmax = zmin + 80; %may need to change or we may need to set scale as part of initialization
           xmin =  median(Cursate_pos(3,:))-30;
           xmax = median(Cursate_pos(3,:))+30;
           
       else
           zmin = median(Cursate_pos(5, :))-40;
           zmax = median(Cursate_pos(5, :))+40;
           xmin = min(last20(1,:));
           xmax = xmin + 60;
       end   
           axis([xmin xmax  zmin zmax]);
           title('Landmarks and Trajectory Last 20 Frames')
           
            hold off
       %%%%%%%plot total trajectory
       subplot(4,6,[15,21])
        plot(alltraj(1,:),alltraj(3,:), '-')
        axis equal;
       title('Full Trajectory')
        
        %%%% number of landmarks tracked over past 20 frames
     
       subplot(4,6,[13,19])
       hold on
        plot(framevec, num_trck, '-');
        title('Landmarks Tracked over Past 20 Frames')
       
        