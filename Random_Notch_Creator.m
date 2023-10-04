%% Notch Formation
%% Notch Properties 
    f0=0;                    % We begin by setting the notch depth as zero (vertical cliff)
    lowel=0;                 % min elevation of the cliff
    highel=11;               % max elevation of the cliff
    b=0;                     % b coefficient values represents the initial cliff plane. We set it onwrds to be generated randomly based on the Measured notch profile set for comparison.                
    ER=0.25;                 % set the Erosion Rate for every simulation   
    tide=0.5;                % total tidal range in m
    SuccessRate=0.3;         % For which fit should it preserve the results. 0.3=70%, 0.2=80%
    Equal_x_Values=119:0.5:134;  % Time range given for the creation of the notch 119 ka to 134 ka BP 
    Orig_x_Values=119:0.5:134;

    Polynomial_Order=2:1:8;      % Interpolation polynomial order used for the interpolation of the randomly generated Sea Level points
 Dt=1;                           
 NoIterations=200000;         %Number of loops of the code
 resample_1= 119:0.1:134;     %resamples the curve in order to save denser amount of points
yinterp_mod=0.32:0.01:10.11; % make points for 'method' interpolation every 10 cm 

%% Path of the folder with the total amount of sea level curves
Orig_Notchpath_2 = ''; %File with the Measured Notch Profiles
Total_Table_path=''; % Folder where the results are saved
filePattern = fullfile(Orig_Notchpath_2, '*.txt');
theFiles = dir(filePattern);
k=1:length(theFiles);

%% Creates directory from the path and keeps only the .dat or .txt files
 for n = 1:NoIterations

randY_values= -5 + (15-(-5)).*rand(length(Orig_x_Values),1); %Generation of random values

% 1. Interpolation method Polynomial
PolOrd=Polynomial_Order(randi(numel(Polynomial_Order)));
% 1.1 Interpolation method Polynomial (with different X values)
p= polyfit(Orig_x_Values, randY_values,PolOrd);
p1= polyval(p,Equal_x_Values);
SLC_Random_sort=[Equal_x_Values; p1]' ; % Creates table with the random values
dz=1100;                     % separate the elevation in dz intervals 
deltaz=(highel-lowel)/dz;  

for i=1:dz+1                 
    
    z(i)=deltaz*(i-1)+lowel;    
         
     for i1=2:length(SLC_Random_sort)           %total amount of years
                 
         t(i1)=SLC_Random_sort(i1,1);      % Time(Years) taken from the SLC
         eb(i1)=SLC_Random_sort(i1,2);     % Sea level taken from SLC
         
         zs1(i1)=eb(i1)-(tide/2);     % floor of the notch(elevation in m)
         zs2(i1)=eb(i1)+(tide/2);     % roof of the notch (elevation in m) 
         a(i,i1)=(ER*Dt)./(eb(i1)-zs1(i1)).*(eb(i1)-zs2(i1)); % factor 'a' affects the curvature of the notch
                                                             
         
         f(i,i1)=a(i,i1).*((z(i)-eb(i1)).^2)+(ER*Dt);         % basic equation of the code
         
%     a(i,i1) will be constant if the erosion rate per year and the tide 
%     are steady but will refer both to elevation and time

%% points from f equation which are only inside
%  the tidal range and exclude the rest 
   
if z(i)>= zs1(i1) && z(i)<=zs2(i1)
    f(i,i1)=f(i,i1-1)+a(i,i1).*((z(i)-eb(i1)).^2)+(ER*Dt);
end
end
end 

% keep the maximum values of erosion

 maxf=[];
 
for it=1:length(z) 
    
maxf=[maxf;max(f(it,:))];  
x_mod=-maxf;
y_mod=z;  
end

%% Comparison of the modeled notch with the original
%Import random notch original data:

k_R=k(randi(numel(k)));
baseFileName = theFiles(k_R).name;
fullFileName = fullfile(theFiles(k_R).folder, baseFileName);
notch_no=extractBetween(fullFileName,"",".txt");
notch_no1 = str2double(notch_no);
Orig_Notch_Data=readmatrix(fullFileName);
x_ORIG= Orig_Notch_Data(:,3); % Original Digitized Notch
y_ORIG= Orig_Notch_Data(:,5); % Original Digitized Notch

%Find min x

XYmax1=[Orig_Notch_Data(end,3), Orig_Notch_Data(end,5)];
[row, col]=find(Orig_Notch_Data(:,5)>=0.32 & Orig_Notch_Data(:,5)<=1.5);
X2max=max(Orig_Notch_Data(row,3));
[a]=find(Orig_Notch_Data(row,3)==X2max);
XYmax2=[X2max+0.5, Orig_Notch_Data(a+row(1,1)-1,5)];

% Calculation of intial cliff plane
tanW=(XYmax1(1,2)-XYmax2(1,2))/(XYmax1(1,1)-XYmax2(1,1)); 
W=atand(abs(tanW));
W1=90-W;
W2=W+W1/2;

%1st inclination

if XYmax1(1,1)<XYmax2(1,1)
    
    if XYmax2(1,2)==0.32
  Ymax2_interp=linspace(XYmax1(1,2), XYmax2(1,2))';
  Xmax2_interp=linspace(XYmax1(1,1), XYmax2(1,1))';
  Xmax2_interp_2=interp1(Ymax2_interp,Xmax2_interp,yinterp_mod,'pchip');
  Inclin_1=[Xmax2_interp_2; yinterp_mod]';
  W=atand(abs(tanW));
  
    elseif XYmax2(1,2)>0.32
   Diff=XYmax2(1,2)-0.32;
   Ymax3=XYmax2(1,2)-Diff;
   bhta=XYmax1(1,2)-Ymax3;
   Xmax3=-((bhta/tanW)-XYmax1(1,1));
   Ymax3_interp=linspace(XYmax1(1,2), Ymax3');
   Xmax3_interp=linspace(XYmax1(1,1), Xmax3');
   Xmax3_interp_3=interp1(Ymax3_interp,Xmax3_interp,yinterp_mod,'pchip');
   Inclin_1=[Xmax3_interp_3; yinterp_mod]';
   W=atand(abs(tanW));
   end

%2nd inclination_Vertical
v=XYmax2(1,1);
v = v(ones(1,size(yinterp_mod,2)),:);
Inclin_2=[v yinterp_mod'];


%3rd inclination
Interval=(Inclin_1(end,1)-Inclin_2(end,1))/2;
Interval_1= Inclin_1(end,1)-Interval;

XYmax4=[Interval_1,Inclin_1(end,2)];
Xmax4_interp=linspace(XYmax4(1,1),Inclin_2(1,1));
Ymax4_interp_4=linspace(XYmax4(1,2),Inclin_2(1,2));
Xmax4_interp_4=interp1(Ymax4_interp_4,Xmax4_interp,yinterp_mod,'pchip');
Inclin_3=[Xmax4_interp_4; yinterp_mod]';
W=W2;
end

if XYmax1(1,1)>XYmax2(1,1)
vv=XYmax2(1,1);
vv = vv(ones(1,size(yinterp_mod,2)),:);
Inclin_2=[vv yinterp_mod'];
end

inclination=[Inclin_1(:,1), Inclin_2(:,1), Inclin_3(:,1)];
deg=randi((size(inclination,2)));

if deg==1
    W=atand(abs(tanW));
elseif deg==2
    W=90;
elseif deg==3
    W=W2;
end

xinterp_mod = interp1(y_mod,x_mod,yinterp_mod,'pchip');  % creates the new modeled points 
notch_mod2=[xinterp_mod;yinterp_mod]';
notch_mod=[(notch_mod2(:,1)+inclination(1:end,deg)) notch_mod2(:,2)];

%Original notch
yinterp=0.32:0.01:10.11;
xinterp = interp1(y_ORIG,x_ORIG,yinterp,'pchip');
notch_orig=[xinterp;yinterp]';       

% Get all the absolute values of the two notches differences in order to get the sum deviation of the whole notch

Subtract_Notch_All=abs(abs(notch_orig(:,1))-abs(notch_mod(:,1)));   % Absolute value of the calculated and the original

p2= polyfit(SLC_Random_sort(:,1),SLC_Random_sort(:,2),PolOrd); % re-calculates the curve and densifies it
p3= polyval(p2,resample_1);
SLC_Random_Interp=[resample_1;p3]';

Total_File=zeros([980 38]);
Subtract_Notch = abs(abs(notch_orig(:,1))-abs(notch_mod(:,1)));
percentageDifference = Subtract_Notch./ abs(notch_orig(:,1)); % Percent by element.

SUB_SUM=mean(percentageDifference);

% Perform linear regression using polyfit
%find where zero starts

coefficients = polyfit(SLC_Random_Interp(:,1), SLC_Random_Interp(:,2), 1);
slope = coefficients(1);
intercept = coefficients(2);

 if SUB_SUM<=SuccessRate; % Result of the deviation from the original notch
Total_File(1:length(SLC_Random_Interp),1)=SLC_Random_Interp(:,1);
Total_File(1:length(SLC_Random_Interp),2)=SLC_Random_Interp(:,2);
Total_File(1:length(notch_mod),3)=notch_mod(:,1);
Total_File(1:length(notch_mod),4)=notch_mod(:,2);
Total_File(1:length(notch_orig),5)=notch_orig(:,1);
Total_File(1:length(notch_orig),6)=notch_orig(:,2);
Total_File(1:length(SUB_SUM),7)=SUB_SUM;
Total_File(1:length(PolOrd),8)=PolOrd;
Total_File(1:length(ER),9)=ER;
Total_File(1:length(ER),10)=k_R;
Total_File(1:length(n),11)=n;
Total_File(1:length(W),12)=W;
Total_File(1:length(deg),13)=deg;
Total_File(1:length(notch_no1),14)=notch_no1;
Total_File(1:length(notch_no1),15)=slope; % Linear Regression
end  

if SUB_SUM<= SuccessRate
    dlmwrite([Total_Table_path  '\Total_Table_RandomAll_n' num2str(n) '.txt'],Total_File,'\t'); %Save values if they fulfill the criteria
end 
 end
 

