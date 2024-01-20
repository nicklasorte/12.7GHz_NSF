clear;
clc;
close all;
close all force;
app=NaN(1);  %%%%%%%%%This is to allow for Matlab Application integration.
format shortG
top_start_clock=clock;
folder1='C:\Local Matlab Data\12.7GHz\Github 12.7GHz NSF';
cd(folder1)
pause(0.1)
addpath('C:\Local Matlab Data\General_Terrestrial_Pathloss')  %%%%%%%%This is where we put the other github repositories
addpath('C:\Local Matlab Data\Generic_Bugsplat')


'Example Code the NSF 12.75GHz coordination zones'


parallel_flag=0%1   %%%%% 0 --> serial, 1 --> parallel


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load NSF Locations Data
load('cell_nsf_group_data.mat','cell_nsf_group_data')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Simulation Input Parameters to change
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % rev=101; %%%%%%NSF Coordination Example with OwensValley and PieTown (Change this number for each different simulation.)
% % grid_spacing=50;  %%%%km:
% % bs_eirp=75; %%%%%EIRP [dBm/100MHz]
% % bs_height=30; %%%%%Height in m
% % array_mitigation=0:10:50;  %%%%%%%%% in dB: [0, 10, 20, 30, 40, 50]
% % loc_idx1=find(contains(cell_nsf_group_data(:,1),'OwensValleyCA_VLBA'));
% % loc_idx2=find(contains(cell_nsf_group_data(:,1),'PieTownNM_VLBA'));
% % cell_locations=cell_nsf_group_data([loc_idx1,loc_idx2],:)
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rev=102; %%%%%%NSF Coordination Example with all Locations
% grid_spacing=20;  %%%%km:
% bs_eirp=75; %%%%%EIRP [dBm/100MHz]
% bs_height=30; %%%%%Height in m
% array_mitigation=0:10:50;  %%%%%%%%% in dB
% loc_idx1=find(contains(cell_nsf_group_data(:,1),'NRQZ'));
% cell_locations=cell_nsf_group_data(loc_idx1,:);
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % rev=103; %%%%%%NSF Coordination Example with OwensValley and PieTown (Change this number for each different simulation.)
% % grid_spacing=5;  %%%%km:
% % bs_eirp=75; %%%%%EIRP [dBm/100MHz]
% % bs_height=30; %%%%%Height in m
% % array_mitigation=0:10:50;  %%%%%%%%% in dB: [0, 10, 20, 30, 40, 50]
% % loc_idx1=find(contains(cell_nsf_group_data(:,1),'OwensValleyCA_VLBA'));
% % loc_idx2=find(contains(cell_nsf_group_data(:,1),'PieTownNM_VLBA'));
% % cell_locations=cell_nsf_group_data([loc_idx1,loc_idx2],:)
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rev=105; %%%%%%NSF Coordination Example
grid_spacing=1;  %%%%km:
bs_eirp=75; %%%%%EIRP [dBm/100MHz]
bs_height=30; %%%%%Height in m
array_mitigation=0:10:50;  %%%%%%%%% in dB
loc_idx1=find(contains(cell_nsf_group_data(:,1),'NRQZ'));
loc_idx2=find(contains(cell_nsf_group_data(:,1),'PieTownNM_VLBA'));
cell_locations=cell_nsf_group_data([loc_idx1,loc_idx2],:)
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Propagation Inputs
FreqMHz=12750; %%%%%%%%MHz
reliability=50;
confidence=50;
Tpol=1; %%%polarization for ITM
sim_radius_km=200; %%%%%%%%Placeholder distance --> Simplification: This is an automated calculation, but requires additional processing time.
radar_threshold=-81; %%%%%Harmful interference threshold -81dBm/100MHz
array_bs_eirp_reductions=bs_eirp; %%%%%Rural, Suburban, Urban cols:(1-3)
required_pathloss=ceil(array_bs_eirp_reductions-radar_threshold);  %%%%%%%%%%%%%%%%%Round up
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Piece together the cell_sim_data
cell_sim_data(:,1)=cell_locations(:,1);
cell_latlon=cell_locations(:,2);
cell_sim_data(:,2)=cell_latlon; %%%Polygon
cell_sim_data(:,3)=cell_latlon; %%%%Protection Points
cell_sim_data(:,4)=num2cell(radar_threshold);
cell_sim_data(:,5)=num2cell(bs_eirp);
cell_sim_data(:,6)=num2cell(bs_height);
cell_sim_data(:,7)={array_mitigation};
cell_sim_data(:,8)=num2cell(grid_spacing);
cell_sim_data(:,9)={array_bs_eirp_reductions};
cell_sim_data(:,10)={reliability};
cell_sim_data(:,11)={confidence};
cell_sim_data(:,12)={FreqMHz};
cell_sim_data(:,13)={Tpol};
cell_sim_data(:,14)=num2cell(sim_radius_km);
cell_sim_data(:,15)=num2cell(required_pathloss);

cell_sim_data'


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Create a Rev Folder
cd(folder1);
pause(0.1)
tempfolder=strcat('Rev',num2str(rev));
[status,msg,msgID]=mkdir(tempfolder);
rev_folder=fullfile(folder1,tempfolder);
cd(rev_folder)
pause(0.1)

tic;
save('reliability.mat','reliability')
save('confidence.mat','confidence')
save('FreqMHz.mat','FreqMHz')
save('Tpol.mat','Tpol')
save('sim_radius_km.mat','sim_radius_km')
save('grid_spacing.mat','grid_spacing')
save('array_bs_eirp_reductions.mat','array_bs_eirp_reductions')
save('bs_height.mat','bs_height')
save('cell_sim_data.mat','cell_sim_data')
save('array_mitigation.mat','array_mitigation')
toc;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Saving the simulation files in a folder for the option to run from a server
%%%%%%%%%For Loop the Locations
[num_locations,~]=size(cell_sim_data)
base_id_array=1:1:num_locations; %%%%ALL
table([1:num_locations]',cell_sim_data(:,1))

for base_idx=1:1:num_locations
    strcat(num2str(base_idx/num_locations*100),'%')

    temp_single_cell_sim_data=cell_sim_data(base_idx,:);
    data_label1=temp_single_cell_sim_data{1};

    %%%%%%%%%Make a Folder each Location/System
    cd(rev_folder);
    pause(0.1)
    tempfolder2=strcat(data_label1);
    [status,msg,msgID]=mkdir(tempfolder2);
    sim_folder=fullfile(rev_folder,tempfolder2);
    cd(sim_folder)
    pause(0.1)

    tic;
    base_polygon=temp_single_cell_sim_data{2};
    save(strcat(data_label1,'_base_polygon.mat'),'base_polygon')

    base_protection_pts=temp_single_cell_sim_data{3};
    save(strcat(data_label1,'_base_protection_pts.mat'),'base_protection_pts')

    radar_threshold=temp_single_cell_sim_data{4};
    save(strcat(data_label1,'_radar_threshold.mat'),'radar_threshold')

    required_pathloss=temp_single_cell_sim_data{15};
    save(strcat(data_label1,'_required_pathloss.mat'),'required_pathloss')
    toc;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Now running the simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wrapper_bugsplat_rev1(app,rev_folder,parallel_flag)






end_clock=clock;
total_clock=end_clock-top_start_clock;
total_seconds=total_clock(6)+total_clock(5)*60+total_clock(4)*3600+total_clock(3)*86400;
total_mins=total_seconds/60;
total_hours=total_mins/60;
if total_hours>1
    strcat('Total Hours:',num2str(total_hours))
elseif total_mins>1
    strcat('Total Minutes:',num2str(total_mins))
else
    strcat('Total Seconds:',num2str(total_seconds))
end


