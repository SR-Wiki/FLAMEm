function rendering1(input1,input2,input3)

load (['Lut/ipic-phase.lut']);
ipic_phase = ipic_phase./max(max(ipic_phase));


input1T = flipud(permute(input1, [3 2 1]));
input2T = flipud(permute(input2, [3 2 1]));
input3T = flipud(permute(input3, [3 2 1]));
input3T = input3T./max(max(max(input3T)));

T1_x = max(input1T,[],3);
T1_speed = max(input2T,[],3);
T1_CEUS = max(input3T,[],3);
sigma = 1;
T1_CEUS = imgaussfilt(T1_CEUS, sigma);

T1_x = T1_x.^0.7;
T1_speed = T1_speed.^0.5;


T1_CEUS = percennorm(T1_CEUS);
T1_x = percennorm(T1_x);
T1_speed = percennorm(T1_speed);


figure; % 
set(gcf, 'Units', 'normalized', 'Position', [0.2, 0.3, 0.6, 0.4]); % 
subplot(1,3,1);imshow(T1_CEUS,[],'Colormap', gray,'InitialMagnification',100);title('Raw');colorbar('southoutside');
subplot(1,3,2);imshow(T1_x,[],'Colormap', gray,'InitialMagnification',100);title('FLAME-intensity');colorbar('southoutside');
subplot(1,3,3);imshow(T1_speed,[],'Colormap', ipic_phase,'InitialMagnification',100);title('FLAME-speed');colorbar('southoutside');







% figure;
% t = tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'compact'); % 
% nexttile; imshow(T1_CEUS,[]); title('Raw');
% nexttile; imshow(T1_x_rgbImage,[]); title('FLAME-intensity');
% nexttile; imshow(T1_speed_rgbImage,[]); title('FLAME-speed');


end




