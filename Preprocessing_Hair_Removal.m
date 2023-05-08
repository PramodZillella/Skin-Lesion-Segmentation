clear all; close all; clc;
%% Load image
input = imread('85_ISIC_0034185.tif');

%% Split image into RGB channels
red_channel = input(:,:,1);
green_channel = input(:,:,2);
blue_channel = input(:,:,3);

%% Plot original image
figure('Name', 'Original Image');
imshow(input);
%title("Dermoscopic Image");
saveas(gcf, 'original_image.png');

%% Plot individual RGB channels
figure('Name', 'Red Channel');
imshow(red_channel);
%title("Extraced Red Channel");
saveas(gcf, 'red_channel.png');
figure('Name', 'Green Channel');
imshow(green_channel);
%title("Extraced Green Channel");
saveas(gcf, 'green_channel.png');
figure('Name', 'Blue Channel');
imshow(blue_channel);
%title("Extraced Blue Channel");
saveas(gcf, 'blue_channel.png');

%% Noise Removal and Hair Replacement
replacedImage = input;
channels = {'Red', 'Green', 'Blue'};
for i=1:3
    I = input(:,:,i);
    se = strel('disk',5);
    hairs = imbothat(I,se);
    
    % Plot hair locations
    figure('Name', channels{i} + " Channel "+" - Hair Locations");
    imshow(hairs);
    %title(channels{i} + " Channel "+" - Hair Locations");
    saveas(gcf, channels{i} + "_hair_locations.png");
    
    % Threshold hair locations
    BW = hairs > 15;
    figure('Name', "Thresholded Hair Locations");
    imshow(BW);
    %title("Thresholded Hair Locations");
    saveas(gcf, channels{i} + "_thresholded_hair_locations.png");
    
    % Enhance hair locations
    BW2 = imerode(BW,strel('disk',2));
    BW1 = imdilate(BW,strel('line',3,45));
    figure('Name', "Enhanced Hair Locations");
    imshow(BW1);
    %title("Enhanced Hair Locations");
    saveas(gcf, channels{i} + "_enhanced_hair_locations.png");
    
    % Remove noise and fill hair regions
    BW2 = double(BW1);
    J = imnoise(BW2,'salt & pepper',0.02);
    K = medfilt2(J,[1 2]);
    replacedImage(:,:,i) = regionfill(I,BW2);
    replacedImage(:,:,i) = medfilt2(replacedImage(:,:,i),[2 2]);
    figure('Name', channels{i} + " Channel "+" - Noise and Hair Removal");
    imshow(K);
    %title(channels{i} + " Channel "+" - Noise and Hair Removal");
    saveas(gcf, channels{i} + "_noise_and_hair_removal.png");
end

% Plot hair removed image
figure('Name', 'Hair Removed Dermoscopic Image');
imshow(replacedImage);
%title("Hair Removed Dermoscopic Image");
saveas(gcf, 'hair_removed_image.png');
