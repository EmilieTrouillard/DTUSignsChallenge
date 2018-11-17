clear;
close all;

%%
validationSet = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 47 49 51 53 55 57 59 61 63 65 67];
Rvalues = [];
Gvalues = [];
Bvalues = [];
RGvalues = [];
GBvalues = [];
BRvalues = [];
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

    Rcomp = I(:,:,1);
    Gcomp = I(:,:,2);
    Bcomp = I(:,:,3);
    %imtool(Gcomp)
    Rvalues = [Rvalues  Rcomp(LabelMap>0)'];
    Gvalues = [Gvalues  Gcomp(LabelMap>0)'];
    Bvalues = [Bvalues  Bcomp(LabelMap>0)'];
    RG = double(Rcomp) - double(Gcomp);
    GB = double(Gcomp) - double(Bcomp);
    BR = double(Bcomp) - double(Rcomp);
    RGvalues = [RGvalues  RG(LabelMap>0)'];
    GBvalues = [GBvalues  GB(LabelMap>0)'];
    BRvalues = [BRvalues  BR(LabelMap>0)'];
    
end
%%
figure; 
subplot(2,2,1); histogram(Rvalues), title('R - signs')
subplot(2,2,2); histogram(Gvalues), title('G - signs')
subplot(2,2,3); histogram(Bvalues), title('B - signs')

figure; 
subplot(2,2,1); histogram(RGvalues), title('R - G - signs')
subplot(2,2,2); histogram(GBvalues), title('G - B - signs')
subplot(2,2,3); histogram(BRvalues), title('B - R - signs')

%figure;    
%subplot(2,2,1);  scatter(Rvalues, Gvalues,'r.'), title('R = f(G) - signs')
%subplot(2,2,2);  scatter(Bvalues, Gvalues,'b.'), title('B = f(G) - signs')
%subplot(2,2,3);  scatter(Rvalues, Bvalues,'r.'), title('R = f(B) - signs')

%figure; 
%subplot(2,2,1); histogram(nRvalues), title('R - no signs')
%subplot(2,2,2); histogram(nGvalues), title('G - no signs')
%subplot(2,2,3); histogram(nBvalues), title('B - no signs')


