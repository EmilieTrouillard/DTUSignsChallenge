clear;
close all;

%%
validationSet = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 47 49 51 53 55 57 59 61 63 65 67];
Hvalues = [];
Svalues = [];
Vvalues = [];
HSvalues = [];
SVvalues = [];
VHvalues = [];
for N = 1:length(validationSet)
    % Current sign id
    nSign = validationSet(N);
    %nSign = 35;
    ImageName = sprintf('DTUSignPhotos/DTUSigns%03d.jpg', nSign);
    LMName    = sprintf('DTUSignPhotos/DTUSigns%03d.txt', nSign);

    %I = imread('DTUSigns065.jpg');
    %LM = dlmread('DTUSigns065.txt');

    I = imread(ImageName);
    LM = dlmread(LMName);

    LabelMap = CreateLabelMapFromAnnotations(I, LM);
    RGBLabels = label2rgb(LabelMap);

    %% Explore the RGB components

    HSV = rgb2hsv(I);
    Hcomp = HSV(:,:,1);
    Scomp = HSV(:,:,2);
    Vcomp = HSV(:,:,3);
    %imtool(Gcomp)
    Hvalues = [Hvalues  Hcomp(LabelMap>0)'];
    Svalues = [Svalues  Scomp(LabelMap>0)'];
    Vvalues = [Vvalues  Vcomp(LabelMap>0)'];
    HS = double(Hcomp) - double(Scomp);
    SV = double(Scomp) - double(Vcomp);
    VH = double(Vcomp) - double(Hcomp);
    HSvalues = [HSvalues  HS(LabelMap>0)'];
    SVvalues = [SVvalues  SV(LabelMap>0)'];
    VHvalues = [VHvalues  VH(LabelMap>0)'];
    
end
%%
figure; 
subplot(2,2,1); histogram(Hvalues), title('H - signs')
subplot(2,2,2); histogram(Svalues), title('S - signs')
subplot(2,2,3); histogram(Vvalues), title('V - signs')

figure; 
subplot(2,2,1); histogram(HSvalues), title('H - S - signs')
subplot(2,2,2); histogram(SVvalues), title('S - V - signs')
subplot(2,2,3); histogram(VHvalues), title('V - H - signs')

%figure;    
%subplot(2,2,1);  scatter(Rvalues, Gvalues,'r.'), title('R = f(G) - signs')
%subplot(2,2,2);  scatter(Bvalues, Gvalues,'b.'), title('B = f(G) - signs')
%subplot(2,2,3);  scatter(Rvalues, Bvalues,'r.'), title('R = f(B) - signs')

%figure; 
%subplot(2,2,1); histogram(nRvalues), title('R - no signs')
%subplot(2,2,2); histogram(nGvalues), title('G - no signs')
%subplot(2,2,3); histogram(nBvalues), title('B - no signs')


